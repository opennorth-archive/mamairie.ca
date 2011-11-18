class Party
  include MongoMapper::Document
  many :people

  key :name, String, required: true, unique: true
  key :slug, String, required: true, unique: true

  ensure_index :name
  ensure_index :slug
end
