class Activity
  include MongoMapper::Document
  belongs_to :person

  key :title, String, required: true
  key :author, String, required: true
  key :body, String, required: true
  key :url, String, required: true
  key :photo_url, String
  key :published_at, Time, required: true
  key :source_id, String
  key :source, String, required: true
  timestamps!

  ensure_index :source
  ensure_index [[:published_at, -1]]
end
