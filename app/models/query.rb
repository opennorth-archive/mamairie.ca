class Query
  include MongoMapper::Document

  key :query, String, required: true
  key :count, Integer

  ensure_index :query
end
