# coding: utf-8
namespace :fixes do
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
    {
      'André Savard' => ['hockey', 'Rétro Laser'],
      'Pierre Mainville' => ['Louis-Pierre Mainville'],
      'Élaine Ayotte' => ['SEPAQ'],
      'Céline Forget' => ['Cinémaboule'],
    }.each do |name,as_eq|
      person = Person.find_by_name! name
      source = person.sources['news.google.ca'] || person.sources.build(name: 'news.google.ca')
      source.extra[:as_eq] = as_eq
      person.save!
    end
  end
end
