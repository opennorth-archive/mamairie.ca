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
      Nokogiri::HTML(Iconv.conv('UTF-8', 'ISO-8859-1', RestClient.post(PEOPLE_URL, action_affiche: 'affiche'))).css('.donn_listeVue1 a').each do |a|
        # @note City mayor has two entries.
        borough_name = a.css('span.titre').text.split(',').last.strip.tr("\u0096\u0097", "–—")
        next if borough_name == 'Ville de Montréal'

        gender, *name = a[:title].split
        name = name.join(' ')

        person = Person.find_by_name(name) || Person.new(name: name)
        if person.new_record?
          log.info "Adding new person #{person.name}"
        end

        doc = Nokogiri::HTML(open("http://ville.montreal.qc.ca#{a[:href]}").read, nil, 'UTF-8')
        src = doc.at_css('.imageDroite').andand[:src]

        person.attributes = {
          email:            doc.at_css('input[name=recipient]').andand[:value],
          gender:           nil,
          positions:        a.inner_html.split('<br>')[1..-1].map(&:strip),
          responsabilities: nil,
          functions:        nil,
          twitter:          nil,
          facebook:         nil,
          wikipedia:        nil,
          web:              nil,
          photo_url:        src && "http://ville.montreal.qc.ca#{src}",
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
              person.functions = strings
            when 'Responsabilité(s)'
              person.responsibilities = {
                # Remove "Responsabilité comme", "Responsabilité au"
                strings[0].sub(':', '').split[2..-1].join(' ').capitalize =>
                strings[1..-1].map{|x| x.sub!(/\A- +/, '')}
              }
            when "Bureau d'arrondissement", "Hôtel de ville"
              numbers = tr.css('td:eq(2)').inner_html.split('<br>').map{|x| x.gsub(/\D/, '')}
              person.addresses.build({
                name:    section,
                address: strings,
                tel:     numbers.first,
                fax:     numbers.last,
              })
            else
              log.warn "Unknown section '#{section}' #{suffix}"
            end
          end
        end

        %w(email photo_url).each do |attribute|
          log.info "Missing #{attribute} #{suffix}" if person[attribute].blank?
        end
        addresses.each do |address|
          %w(tel fax).each do |attribute|
            log.info "Missing #{attribute} #{suffix}" if address[attribute].blank?
          end
        end

        person.save!
      end
    end
  end
end
