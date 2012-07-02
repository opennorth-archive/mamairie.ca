class District
  include MongoMapper::Document
  plugin MongoMapper::Plugins::IdentityMap
  belongs_to :borough

  key :name, String, required: true, unique: true
  key :slug, String, required: true, unique: true
  key :short_name, String

  ensure_index :name
  ensure_index :slug

  before_validation :set_slug

private

  def set_slug
    self.slug = name.slug if name
  end
end
