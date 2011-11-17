class Party
  include MongoMapper::Document
  many :people

  key :name, String

end
