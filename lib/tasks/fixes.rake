# coding: utf-8
namespace :fixes do
  EXCLUSIONS = {
    'Élaine Ayotte' => ['SEPAQ'],
    'Daniel Bélanger' => ['procureur de la Couronne', 'musiciens', 'musique', 'musicale', 'chanson', 'chansons'],
    'Céline Forget' => ['Cinémaboule'],
    'Pierre Mainville' => ['Louis-Pierre Mainville'],
    'François Robert' => ['Jean-François Robert', 'Photo François Robert'],
    'André Savard' => ['hockey', 'Rétro Laser'],
    'Gilles Deguire' => ['Ri-Do-Rare'],
  }

  desc 'Add alternative keywords for Google News Search'
  task :google_news => :environment do
    {
      'Bertrand A. Ward' => 'Bertrand Ward',
      'Christian B. Dubois' => 'Christian Dubois',
      'Dimitrios Jim Beis' => 'Jim Beis',
    }.each do |name,q|
      person = Person.find_by_name! name
      source = person.sources['news.google.ca'] || person.sources.build(name: 'news.google.ca')
      source.extra[:q] = q
      person.save!
    end
    EXCLUSIONS.each do |name,as_eq|
      person = Person.find_by_name! name
      source = person.sources['news.google.ca'] || person.sources.build(name: 'news.google.ca')
      source.extra[:as_eq] = as_eq
      person.save!
    end
  end

  desc 'Update news items from certain people'
  task :update_news => :environment do
    EXCLUSIONS.each do |name|
      person = Person.find_by_name! name
      person.activities.where(source: Activity::GOOGLE_NEWS).each{|x| x.destroy!}
      Activity.google_news(person)
    end
  end

  desc 'Add short names to boroughs'
  task :boroughs => :environment do
    {
      'cdn-ndg' => 'CDN-NDG',
      'mhm' => 'MHM',
      'rdp-pat' => 'RDP-PAT',
      'vsp' => 'VSP',
    }.each do |slug,short_name|
      borough = Borough.find_by_slug! slug
      borough.short_name = short_name
      borough.save!
    end
  end

  desc 'Add short names to districts'
  task :districts => :environment do
    {
      'Saint-Henri—Petite-Bourgogne—Pointe-Saint-Charles' => 'St-Henri—Petite-Bourgogne—Pointe-St-Charles'
    }.each do |name,short_name|
      district = District.find_by_name! name
      district.short_name = short_name
      district.save!
    end
  end
end
