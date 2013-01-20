Popolo::Person.class_eval do
  # @return [String] @todo
  # @todo necessary method?
  def source_id
    source_url[/\d+\z/]
  end

  # @return [String] the person's external URL
  # @todo differs from source_url?
  def external_url
    "http://ville.montreal.qc.ca/portal/page?_pageid=5798,85809754&_dad=portal&_schema=PORTAL&id=#{source_id}"
  end
end
