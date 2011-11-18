namespace :scraper do
  task :retrieve => :environment do
    require 'runner'
    Runner.new.run [
      'retrieve',
    ]
  end

  # Run when photo_url changes
  task :images => :environment do
    require 'open-uri'
    Person.all.each do |person|
      filename = File.join Rails.root, 'app', 'assets', 'images', 'photos', "#{person.slug}.jpg"
      unless person.photo_url.nil? or File.exist?(filename)
        File.open(filename, 'wb') do |f|
          f.write open(person.photo_url).read
        end
      end
    end
  end

  # Run when Wikipedia changes
  task :wikipedia => :environment do
    
  end

  task :twitter => :environment do

  end

  task :google_news => :environment do

  end
end
