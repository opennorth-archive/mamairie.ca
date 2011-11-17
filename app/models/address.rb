class Address
  include MongoMapper::EmbeddedDocument

  key :name, String
  key :address, Array
  key :tel, String
  key :fax, String

end
