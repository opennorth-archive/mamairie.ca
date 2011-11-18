class Party
  include MongoMapper::Document
  many :people

  key :name, String
  key :slug, String

  ensure_index :name
  ensure_index :slug

  validates_presence_of :name, :slug
end
