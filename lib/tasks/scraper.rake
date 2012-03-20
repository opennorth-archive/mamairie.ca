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
end
