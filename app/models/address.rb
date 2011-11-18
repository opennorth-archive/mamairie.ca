class Address
  include MongoMapper::EmbeddedDocument

  key :name, String
  key :address, Array
  key :tel, Integer
  key :fax, Integer

  validates_presence_of :name, :address, :tel, :fax
end
