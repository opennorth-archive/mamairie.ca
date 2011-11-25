# coding: utf-8
require 'csv'
require 'iconv'
require 'open-uri'

require 'andand'
require 'nokogiri'
require 'rest-client'
require 'unbreakable'

module VilleMontrealQcCa
  class Scraper < Unbreakable::Scraper
    SPREADSHEET_URL = 'https://spreadsheets.google.com/pub?hl=en&hl=en&key=0AgjCpacWYedndEtSSGVtakd1NVp1bEFjWERSN291eGc&single=true&gid=0&output=csv'
    PEOPLE_URL = 'http://ville.montreal.qc.ca/portal/page?_pageid=5798,85809573&_dad=portal&_schema=PORTAL'
    GENDER_MAP = {'Monsieur' => 'm', 'Madame' => 'f'}
    DISTRICT_MAP = {
      "Champlain-L'Île-des-Sœurs"   => "Champlain—L'Île-des-Sœurs",
      'Maisonneuve-Longue-Pointe'   => 'Maisonneuve—Longue-Pointe',
      'Saint-Henri-Petite-Bourgogne-Pointe-Saint-Charles' => 'Saint-Henri—Petite-Bourgogne—Pointe-Saint-Charles',
      'Saint-Paul - Émard'          => 'Saint-Paul—Émard',
      'Sault-Saint-Louis (poste 1)' => 'Sault-Saint-Louis',
      'Sault-Saint-Louis (poste 2)' => 'Sault-Saint-Louis',
    }

    def retrieve(args)
      csv = {}
      CSV.parse(open(SPREADSHEET_URL).read, headers: true) do |row|
        csv[row['name']] = {
          twitter: row['twitter'] && row['twitter'].sub(/\A@/, '').strip,
          facebook: row['facebook'].andand.strip,
          youtube: row['youtube'].andand.strip,
          flickr: row['flickr'].andand.strip,
          wikipedia: {
            en: row['wikipedia_en'] && row['wikipedia_en'].sub(%r{\Ahttp://en\.wikipedia\.org/wiki/}, '').strip,
            fr: row['wikipedia_fr'] && row['wikipedia_fr'].sub(%r{\Ahttp://fr\.wikipedia\.org/wiki/}, '').strip,
          },
          web: {
            en: row['web_en'].andand.strip,
            fr: row['web_fr'].andand.strip,
          },
        }
      end

      # @todo mark people for hiding
      previous = nil
      Nokogiri::HTML(Iconv.conv('UTF-8', 'ISO-8859-1', RestClient.post(PEOPLE_URL, action_affiche: 'affiche'))).css('.donn_listeVue1 a').each do |a|
        borough_name = a.css('span.titre').text.split(',').last.strip.tr("\u0096\u0097", "–—")
        positions = a.inner_html.split('<br>')[1..-1].map(&:strip)
        # @note City mayor has two entries.
        next if borough_name == 'Ville de Montréal' or ['Conseiller de la Ville désigné', 'Conseillère de la Ville désignée'].include?(positions.first)

        gender, *name = a[:title].split
        name = name.join(' ')

        person = Person.find_by_name(name) || Person.new(name: name)
        if person.new_record?
          log.info "Adding new person #{person.name}"
        end

        begin
          doc = Nokogiri::HTML(open("http://ville.montreal.qc.ca#{a[:href]}").read, nil, 'UTF-8')
        rescue Timeout::Error
          log.error "Timeout, retrying in 2..."
          sleep 2
          retry
        end

        src = doc.at_css('.imageDroite').andand[:src]

        person.attributes = {
          email:            doc.at_css('input[name=recipient]').andand[:value],
          gender:           nil,
          positions:        positions,
          responsibilities: nil,
          functions:        nil,
          twitter:          nil,
          facebook:         nil,
          wikipedia:        nil,
          web:              nil,
          photo_src:        src && "http://ville.montreal.qc.ca#{src}",
          source_url:       a[:href],
          borough_id:       nil,
          district_id:      nil,
          party_id:         nil,
        }
        person.addresses.clear

        suffix = "for #{person.name} (#{a[:href].split('=').last.to_i})"

        borough = Borough.find_by_name(borough_name)
        if borough.nil?
          log.error "Unknown borough '#{borough_name}' #{suffix}"
        else
          person.borough_id = borough.id
        end

        if GENDER_MAP.key? gender
          person.gender = GENDER_MAP[gender]
        else
          log.warn "Unknown gender '#{gender}' #{suffix}"
        end

        if csv.key? name
          person.attributes = csv[name]
        else
          log.warn "Missing spreadsheet row #{suffix}"
        end

        doc.css('#print tr').each_with_index do |tr,index|
          if index.zero?
            parts = tr.text.split("\n").map(&:strip).reject(&:empty?)

            if parts.size == person.positions.size + 3 # borough, district, party
              district_name = DISTRICT_MAP[parts[1]] || parts[1]
              if %w(Ouest Est Centre).include? district_name
                district_name = "#{borough_name}-#{district_name}"
              end
              district = District.find_by_name(district_name)
              if district.nil?
                log.error "Unknown district '#{district_name}' #{suffix}"
              else
                person.district_id = district.id
              end
            end

            party_name = parts.last.sub(/ \([A-Z]{2,3}\)\z/, '')
            party = Party.find_by_name(party_name)
            if party.nil?
              log.error "Unknown party '#{party_name}' #{suffix}"
            else
              person.party_id = party.id
            end
          else
            section = tr.at_css('b').text.strip
            strings = tr.css('td:eq(1)').inner_html.split('<br>')[1..-1].map(&:strip)
            case section
            when 'Fonction(s) et comité(s) stratégique(s)'
              person.functions = strings.map{|x| x.sub(/[:;]\z/, '')}
            when 'Responsabilité(s)'
              person.responsibilities = {
                # Remove "responsabilité comme", "responsabilité au"
                strings[0].sub(':', '').split[2..-1].join(' ').capitalize =>
                strings[1..-1].map{|x| x.sub!(/\A- +/, '')}
              }
            when "Bureau d'arrondissement", "Hôtel de ville"
              numbers = tr.css('td:eq(2)').text
              tel = numbers[/Téléphone[[:space:]:]+([0-9 -]+)/, 1]
              fax = numbers[/Télécopieur[[:space:]:]+([0-9 -]+)/, 1]
              ext = numbers[/poste (\d+)/, 1]
              person.addresses.build({
                name:    section,
                address: strings,
                tel:     tel.andand.gsub(/\D/, ''),
                fax:     fax.andand.gsub(/\D/, ''),
                ext:     ext,
              })
            else
              log.warn "Unknown section '#{section}' #{suffix}"
            end
          end
        end

        %w(email photo_src).each do |attribute|
          log.info "Missing #{attribute} #{suffix}" if person[attribute].blank?
        end
        person.addresses.each do |address|
          %w(tel fax).each do |attribute|
            log.info "Missing #{attribute} #{suffix}" if address[attribute].blank?
            unless address[attribute].blank? or address[attribute].to_s.size == 10
              log.info "#{attribute} (#{address[attribute]}) doesn't have 10 digits #{suffix}"
            end
          end
        end

        person.save!
      end
    end
  end
end
