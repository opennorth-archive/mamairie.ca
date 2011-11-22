class Source
  include MongoMapper::EmbeddedDocument

  key :name, String, required: true
  key :etag, String
  key :last_modified, Time, required: true
  key :extra, Hash
end