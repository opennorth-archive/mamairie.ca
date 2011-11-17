class Person
  include MongoMapper::Document
  belongs_to :borough
  belongs_to :district
  belongs_to :party
  many :addresses

  key :name, String
  key :slug, String
  key :email, String
  key :gender, String
  key :positions, Array
  key :responsibilities, Array
  key :twitter, String
  key :facebook, String
  key :wikipedia, Hash
  key :web, Hash
  key :photo_url, String
  key :source_url, String
  key :source_id, Integer
  timestamps!

end
