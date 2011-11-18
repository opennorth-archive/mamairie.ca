class Person
  include MongoMapper::Document
  belongs_to :borough
  belongs_to :district
  belongs_to :party
  many :addresses
  many :activities

  key :name, String, required: true
  key :slug, String, required: true
  key :email, String
  key :gender, String, required: true
  key :positions, Array, required: true
  key :responsibilities, Hash
  key :functions, Array
  key :twitter, String
  key :facebook, String
  key :wikipedia, Hash
  key :web, Hash
  key :photo_url, String
  key :source_url, String, required: true
  timestamps!

  ensure_index :name
  ensure_index :slug

  def find_address_by_name(name)
    addresses.detect{|address| address.name == name}
  end
end
