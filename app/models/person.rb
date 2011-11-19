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

  def twitter_url
    "http://twitter.com/#{twitter}" if twitter
  end

  def photo_filename
    File.join Rails.root, 'app', 'assets', 'images', 'photos', "#{slug}.jpg"
  end

  def photo_retrieved?
    File.exist? photo_filename
  end

  def photo_path
    if photo_retrieved?
      "photos/#{person.slug}.jpg"
    else
      photo_url
    end
  end

  def others_in_borough
    borough.people.sort(:name.asc).all - [self]
  end

  # @todo web and wikipedia methods that get the best localization (add to borough and person pages)

private

  def set_slug
    self.slug = name.slug.sub(/-.+-/, '-') if name
  end
end
