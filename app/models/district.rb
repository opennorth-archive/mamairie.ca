class District
  include MongoMapper::Document
  belongs_to :borough

  key :name, String
  key :slug, String

  ensure_index :name
  ensure_index :slug

  validates_presence_of :name, :slug
end
