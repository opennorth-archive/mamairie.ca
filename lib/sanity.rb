# coding: utf-8
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
    end + Person.all.map(&:photo_src) + ['http://ville.montreal.qc.ca/portal/page?_pageid=5798,85809573&_dad=portal&_schema=PORTAL']
    uris.flatten.compact.each do |uri|
      Faraday.head(uri).status.should == 200
      Faraday.get(uri).body.should_not match /Fatal error/i
    end
  end

  it 'should get 302 response code' do
    uris = Borough.fields(:slug).all.map(&:url)
    uris.each do |uri|
      # http://ville.montreal.qc.ca/portal/page?_pageid=67,297449&_dad=portal&_schema=PORTAL
      Faraday.head(uri).env[:response_headers][:location].should_not match /404|67,297449/
    end
  end

  it 'should get empty feed' do
    [
      'Andrée Champoux',
      'Anna Nunes',
      'Aref Salem',
      'Clementina Teti-Tomassi',
      'Diane Gibb',
      'Émilie Thuillier',
      'Frank Venneri',
      'Frantz Benjamin',
      'Jean-Marc Gibeau',
      'Laura-Ann Palestini',
      'Michèle D. Biron',
      'Michèle Biron',
      'Michèle Di Genova Zammit',
      'Michèle Di Genova',
      'Michèle Zammit',
      'Ross Blackhurst',
    ].each do |name|
      url = 'http://news.google.ca/news?' + {output: 'rss', q: %("#{name}")}.to_param
      entries = Feedzirra::Feed.fetch_and_parse(url).entries
      entries.should be_empty, "expected #{url} to be empty, got #{entries.inspect}"
    end
  end
end
