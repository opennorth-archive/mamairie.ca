namespace :scraper do
  task :retrieve => :environment do
    require 'runner'
    Runner.new.run [
      'retrieve',
    ]
  end

  task :process => :environment do
    require 'runner'
    Runner.new.run [
      'process',
    ]
  end

  task :images => :environment do
    Person.all.each do |person|
      filename = File.join Rails.root, 'app', 'assets', 'images', 'photos', "#{person.slug}.jpg"
      unless person.photo_url.nil? or File.exist?(filename)
        File.open(filename, 'wb') do |f|
          f.write open(person.photo_url).read
        end
      end
    end
  end
end
