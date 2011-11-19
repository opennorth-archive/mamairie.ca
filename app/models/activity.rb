class Activity
  include MongoMapper::Document
  belongs_to :person

  key :body, String, required: true
  key :url, String, required: true
  key :published_at, Time, required: true
  key :source, String, required: true
  key :extra, Hash
  timestamps!

  ensure_index :source
  ensure_index [[:published_at, -1]]
end
