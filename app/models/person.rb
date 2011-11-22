class Person
  include MongoMapper::Document
  mount_uploader :photo, PhotoUploader

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
  key :first_name, String, required: true
  key :last_name, String, required: true
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
  key :photo_src, String
  key :party_slug, String, required: true
  key :source_url, String, required: true
  timestamps!

  ensure_index :name
  ensure_index :slug
  ensure_index :last_name

  before_validation :set_attributes

  def twitter_url
    "http://twitter.com/#{twitter}" if twitter
  end

  def others_in_borough
    Person.where(:borough_id => borough_id).order(:name)
  end

  def wikipedia_url
    wikipedia[I18n.locale]
  end

  def web_url
    web[I18n.locale]
  end

private

  def set_attributes
    self.slug = name.slug.sub(/-.+-/, '-') if name
    self.first_name = name[/\A\S+/] if name
    self.last_name = name[/\S+\z/] if name
    self.party_slug = party.slug if party
  end
end
