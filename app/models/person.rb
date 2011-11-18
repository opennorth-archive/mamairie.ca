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
  key :responsibilities, Hash
  key :functions, Array
  key :twitter, String
  key :facebook, String
  key :wikipedia, Hash
  key :web, Hash
  key :photo_url, String
  key :source_url, String
  key :source_id, Integer
  timestamps!

  validates_presence_of :name, :slug, :gender, :positions, :responsibilities,
    :functions, :source_url, :source_id

  def find_address_by_name(name)
    addresses.detect{|address| address.name == name}
  end
end
