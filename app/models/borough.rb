class Borough
  include MongoMapper::Document
  many :people

  key :name, String
  key :services_id, String

end
