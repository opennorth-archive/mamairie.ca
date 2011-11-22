class Activity
  TWITTER = 'twitter.com'
  GOOGLE_NEWS = 'news.google.ca'

  include MongoMapper::Document
  belongs_to :person
  belongs_to :party
  belongs_to :borough
  belongs_to :district

  key :body, String, required: true
  key :url, String, required: true
  key :published_at, Time, required: true
  key :source, String, required: true
  key :extra, Hash
  timestamps!

  def publisher_url
    case source
    when TWITTER
      "http://twitter.com/#{extra[:screen_name]}"
    end
  end

  def image
    case source
    when TWITTER
      extra[:profile_image_url]
    when GOOGLE_NEWS
      extra[:image]
    end
  end

  ensure_index :source
  ensure_index [[:published_at, -1]]
end
