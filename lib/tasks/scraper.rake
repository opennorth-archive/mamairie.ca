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

  desc 'Import biography from each political party'
  task :biography => :environment do

    Person.all.each do |person|

      for lang in %w(fr en)

        if person.web[lang].blank? || Faraday.head(person.web[lang]).status != 200
          puts person.name + " URL is broken or doesn\'t exist for " + lang
          next
        else
          doc = Nokogiri::HTML(open(person.web[lang]), nil, "UTF-8") # I suppose there's a url field in the DB
          puts person.name + ' ' +  person.web[lang] 
        end

        # Research by party
        
        if person.party_name == "Union Montréal"
          doc.css('.section').each do |node| # Parse and get nodes inside div .oi1
              person.bio[lang] =  node.css('p').text # Get every p tags inside the previous div 
          end   
        elsif person.party_name == 'Vision Montréal'
          if doc.at_css('div#texte')         
            person.bio[lang] = doc.at_css('div#texte').text
          end
        elsif person.party_name == 'Projet Montréal'
          if doc.at_css('div.oi1')
            doc.css('.oi1').each do |node| # Parse and get nodes inside div .oi1 for "the leader"
              person.bio[lang] =  node.css('p').text # Get every p tags inside the previous div
            end
          else
            doc.css('.oi4').each do |node| # Parse and get nodes inside div .oi4
              person.bio[lang] =  node.css('p').text # Get every p tags inside the previous div
            end
          end
        end

        person.save!
      end
    end
  end
end
