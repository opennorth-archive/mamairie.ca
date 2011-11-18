class Address
  include MongoMapper::EmbeddedDocument

  key :name, String, required: true
  key :address, Array, required: true
  key :tel, Integer
  key :fax, Integer

end
