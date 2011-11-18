# Run with rspec
require File.expand_path('../../spec/spec_helper', __FILE__)
require 'rspec/rails'
require 'faraday'

describe MaMairie do
  it 'should get 200 response code' do
    uris = Person.all.map do |x|
      [
        x.twitter,
        x.facebook,
        x.wikipedia[:en],
        x.wikipedia[:fr],
        x.web[:en],
        x.web[:fr],
      ]
    end + ['http://ville.montreal.qc.ca/portal/page?_pageid=5798,85809573&_dad=portal&_schema=PORTAL']
    uris.flatten.compact.each do |uri|
      Faraday.head(uri).status.should == 200
    end
  end

  it 'should get 302 response code' do
    uris = Borough.all.map(&:url)
    uris.each do |uri|
      # http://ville.montreal.qc.ca/portal/page?_pageid=67,297449&_dad=portal&_schema=PORTAL
      Faraday.head(uri).env[:response_headers][:location].should_not match /404|67,297449/
    end
  end
end
