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
  timestamps!

  ensure_index :name
  ensure_index :slug

  validates_presence_of :name, :slug, :gender, :positions, :source_url

  def find_address_by_name(name)
    addresses.detect{|address| address.name == name}
  end
end
