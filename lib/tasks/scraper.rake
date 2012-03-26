# coding: utf-8
namespace :scraper do
  desc 'Add mayors and councillors'
  task :retrieve => :environment do
    require 'runner'
    Runner.new.run [
      'retrieve',
    ]
  end

  # Run on occasion
  desc 'Download photos of mayors and councillors'
  task :photos => :environment do
    # https://github.com/technoweenie/faraday/wiki/Setting-up-SSL-certificates
    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    Person.where(photo_src: {'$exists' => true}).each do |person|
      # On HTTP 404, HEAD requests raise errors. Although this line would be
      # cleaner with GET, HEAD is faster.
      unless (Faraday.head(person.photo.url).status rescue false)
        begin
          person.remote_photo_url = person.photo_src
          person.save!
        rescue => e
          puts e.message
        end
      end
    end
  end

  # Run on occasion
  desc 'Import Wikipedia content'
  task :wikipedia => :environment do
    # @todo
  end

  desc 'Import Twitter tweets'
  task :twitter => :environment do

    Person.where(twitter: {'$exists' => true}).sort(:name.asc).all.each do |person|
      Activity.twitter(person)
    end
  end

  desc 'Import Google News articles'
  task :google_news => :environment do
    Person.sort(:name.asc).all.each do |person|
      Activity.google_news(person)
    end
  end

  desc 'Import person biography'
  task :biography => :environment do
    Person.all.each do |person|
      %w(fr en).each do |locale|
        if person.web[locale].blank?
          puts "#{person.name} #{locale} URL doesn't exist"
          next
        elsif Faraday.head(person.web[locale]).status != 200
          puts "#{person.name} #{locale} URL is broken"
          next
        end

        doc = Nokogiri::HTML(open(person.web[locale]), nil, 'utf-8')
        person.biography[locale] = case person.party_name
        when 'Union Montréal'
          doc.css('.section').css('p').text
        when 'Vision Montréal'
          if doc.at_css('div#texte')
            doc.at_css('div#texte').text
          end
        when 'Projet Montréal'
          if doc.at_css('div.oi1')
            doc.css('.oi1').css('p').text
          else
            doc.css('.oi4').css('p').text
          end
        end
        person.save!
      end
    end
  end
end
