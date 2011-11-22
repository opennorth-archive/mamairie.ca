# coding: utf-8
namespace :fixes do
  desc 'Add alternative keywords for Google News Search'
  task :google_news => :environment do
    {
      'Bertrand A. Ward' => 'Bertrand Ward',
      'Christian B. Dubois' => 'Christian Dubois',
      'Dimitrios Jim Beis' => 'Jim Beis',
    }.each do |name,alt|
      person = Person.find_by_name! name
      source = person.sources['news.google.ca'] || person.sources.build(name: 'news.google.ca')
      source.extra[:q] = alt
      person.save!
    end
    {
      'André Savard' => 'hockey',
    }.each do |name,exclude|
      person = Person.find_by_name! name
      source = person.sources['news.google.ca'] || person.sources.build(name: 'news.google.ca')
      source.extra[:as_eq] = exclude
      person.save!
    end
  end
end
