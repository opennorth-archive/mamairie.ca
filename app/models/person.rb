class Person
  include MongoMapper::Document
  belongs_to :borough
  belongs_to :party
  many :addresses

  key :name, String
  key :email, String
  key :positions, Array
  key :responsibilities, Array
  key :wikipedia, Hash
  key :facebook, String
  key :twitter, String
  key :web, String
  key :photo_url, String
  key :source_url, String
  key :source_id, Integer
  timestamps!

end
