class Person
  include MongoMapper::Document
  belongs_to :borough
  belongs_to :district
  belongs_to :party
  many :addresses do
    def [](name)
      detect{|x| x.name == name.to_s}
    end
  end
  many :sources do
    def [](name)
      detect{|x| x.name == name.to_s}
    end
  end
  many :activities

  key :name, String, required: true
  key :slug, String, required: true
  key :email, String
  key :gender, String, required: true, in: %w(m f)
  key :positions, Array, required: true
  key :responsibilities, Hash
  key :functions, Array
  key :twitter, String
  key :facebook, String
  key :wikipedia, Hash
  key :web, Hash
  key :photo_url, String
  key :source_url, String, required: true
  timestamps!

  ensure_index :name
  ensure_index :slug

  before_validation :set_slug

private

  def set_slug
    self.slug = name.slug.sub(/-.+-/, '-') if name
  end
end
