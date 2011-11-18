# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# @note Same abbreviations as used by ville.montreal.qc.ca
[
  {slug: 'um', name: 'Union Montréal'},
  {slug: 'vm', name: 'Vision Montréal'},
  {slug: 'pm', name: 'Projet Montréal'},
  {slug: 'ind', name: 'Indépendant'},
].each do |params|
  Party.create! params
end

# @note Same abbreviations as used by ville.montreal.qc.ca
[
  {slug: 'ahuntsic-cartierville', name: 'Ahuntsic-Cartierville', services_id: 'Ahuntsic - Cartierville'},
  {slug: 'anjou', name: 'Anjou', services_id: 'Anjou'},
  {slug: 'cdn-ndg', name: 'Côte-des-Neiges—Notre-Dame-de-Grâce', services_id: 'Côte-des-Neiges - Notre-Dame-de-Grâce'},
  {slug: 'lachine', name: 'Lachine', services_id: 'Lachine'},
  {slug: 'lasalle', name: 'LaSalle', services_id: 'LaSalle'},
  {slug: 'plateau', name: 'Le Plateau-Mont-Royal', services_id: 'Le Plateau-Mont-Royal'},
  {slug: 'sud-ouest', name: 'Le Sud-Ouest', services_id: 'Le Sud-Ouest'},
  {slug: 'ibsg', name: "L'Île-Bizard—Sainte-Geneviève", services_id: "L'Île-Bizard - Sainte-Geneviève"},
  {slug: 'mhm', name: 'Mercier—Hochelaga-Maisonneuve', services_id: 'Mercier - Hochelaga-Maisonneuve'},
  {slug: 'mtlnord', name: 'Montréal-Nord', services_id: 'Montréal-Nord'},
  {slug: 'outremont', name: 'Outremont', services_id: 'Outremont'},
  {slug: 'pierrefonds-roxboro', name: 'Pierrefonds-Roxboro', services_id: 'Pierrefonds - Roxboro'},
  {slug: 'rdp-pat', name: 'Rivière-des-Prairies—Pointe-aux-Trembles', services_id: 'Rivière-des-Prairies - Pointe-aux-Trembles'},
  {slug: 'rpp', name: 'Rosemont—La Petite–Patrie', services_id: 'Rosemont - La Petite-Patrie'},
  {slug: 'saint-laurent', name: 'Saint-Laurent', services_id: 'Saint-Laurent'},
  {slug: 'st-leonard', name: 'Saint-Léonard', services_id: 'Saint-Léonard'},
  {slug: 'verdun', name: 'Verdun', services_id: 'Verdun'},
  {slug: 'villemarie', name: 'Ville-Marie', services_id: 'Ville-Marie'},
  {slug: 'vsp', name: 'Villeray—Saint-Michel—Parc-Extension', services_id: 'Villeray - Saint-Michel - Parc-Extension'},
].each do |params|
  Borough.create! params
end

{
  'ahuntsic-cartierville' => [
    'Ahuntsic',
    'Bordeaux-Cartierville',
    'Saint-Sulpice',
    'Sault-au-Récollet',
  ],
  'anjou' => [
    'Anjou-Centre',
    'Anjou-Est',
    'Anjou-Ouest',
  ],
  'cdn-ndg' => [
    'Côte-des-Neiges',
    'Darlington',
    'Loyola',
    'Notre-Dame-de-Grâce',
    'Snowdon',
  ],
  'lachine' => [
    'Canal',
    'Fort-Rolland',
    'J.-Émery-Provost',
  ],
  'lasalle' => [
    'Cecil-P.-Newman',
    'Sault-Saint-Louis',
  ],
  "ibsg" => [
    'Denis-Benjamin-Viger',
    'Jacques-Bizard',
    'Pierre-Foretier',
    'Sainte-Geneviève',
  ],
  'mhm' => [
    'Hochelaga',
    'Louis-Riel',
    'Maisonneuve—Longue-Pointe',
    'Tétreaultville',
  ],
  'mtlnord' => [
    'Marie-Clarac',
    'Ovide-Clermont',
  ],
  'outremont' => [
    'Claude-Ryan',
    'Jeanne-Sauvé',
    'Joseph-Beaubien',
    'Robert-Bourassa',
  ],
  'pierrefonds-roxboro' => [
    'Bois-de-Liesse',
    'Cap-Saint-Jacques',
  ],
  'plateau' => [
    'De Lorimier',
    'Jeanne-Mance',
    'Mile End',
  ],
  'rdp-pat' => [
    'La Pointe-aux-Prairies',
    'Pointe-aux-Trembles',
    'Rivière-des-Prairies',
  ],
  'rpp' => [
    'Étienne-Desmarteau',
    'Marie-Victorin',
    'Saint-Édouard',
    'Vieux-Rosemont',
  ],
  'saint-laurent' => [
    'Côte-de-Liesse',
    'Norman-McLaren',
  ],
  'st-leonard' => [
    'Saint-Léonard-Est',
    'Saint-Léonard-Ouest',
  ],
  'sud-ouest' => [
    'Saint-Henri—Petite-Bourgogne—Pointe-Saint-Charles',
    'Saint-Paul—Émard',
  ],
  'verdun' => [
    "Champlain—L'Île-des-Sœurs",
    'Desmarchais-Crawford',
  ],
  'villemarie' => [
    'Peter-McGill',
    'Saint-Jacques',
    'Sainte-Marie',
  ],
  'vsp' => [
    'François-Perrault',
    'Parc-Extension',
    'Saint-Michel',
    'Villeray',
  ],
}.each do |slug,districts|
  borough = Borough.find_by_slug(slug)
  districts.each do |name|
    borough.districts.create! name: name, slug: name.slug
  end
end
