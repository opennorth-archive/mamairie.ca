class District
  include MongoMapper::Document
  belongs_to :borough

  key :name, String, required: true, unique: true
  key :slug, String, required: true, unique: true

  ensure_index :name
  ensure_index :slug
end
