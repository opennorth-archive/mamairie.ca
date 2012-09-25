# A user's search query.
class Query
  include Mongoid::Document

  # The query's terms.
  field :query, type: String
  # Whether matching records were found.
  field :found, type: Boolean, default: true
  # How many times these terms were queried.
  field :count, type: Integer

  validates_presence_of :query

  index query: 1
end
