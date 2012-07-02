class Party
  include MongoMapper::Document
  plugin MongoMapper::Plugins::IdentityMap
  many :people

  key :name, String, required: true, unique: true
  key :slug, String, required: true, unique: true

  ensure_index :name
  ensure_index :slug
end
