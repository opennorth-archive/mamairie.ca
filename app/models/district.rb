class District
  include MongoMapper::Document
  belongs_to :borough

  key :name, String
  key :slug, String

end
