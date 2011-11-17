class Party
  include MongoMapper::Document
  many :people

  key :name, String
  key :slug, String

end
