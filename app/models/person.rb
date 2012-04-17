# coding: utf-8
require 'mail'
class Person
  class InvalidEmail < StandardError; end

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
  key :youtube, String
  key :flickr, String
  key :biography, Hash
  key :wikipedia, Hash
  key :web, Hash
  key :photo_src, String
  key :source_url, String, required: true
  key :borough_name, String, required: true
  key :borough_slug, String, required: true
  key :party_name, String, required: true
  key :party_slug, String, required: true
  key :subscribers, Array
  timestamps!

  ensure_index :name
  ensure_index :slug
  ensure_index :last_name

  before_validation :set_attributes

  def position
    positions.first[/\A\S+/]
  end

  def other_positions
    positions[1..-1]
  end

  def district_name
    district.short_name || district.name
  end

  def mayor?
    %w(Maire Mairesse).include? position
  end

  def human_functions
    functions.map do |function|
      [ /\AMembre de la commission (de|du|sur) /i,
        /\AMembre d[eu] /i,
        / – (Agglomération|Ville) de Montréal\z/i,
        / de la Communauté métropolitaine de Montréal\z/i,
        /\(\p{Lu}+\)\z/i,
      ].reduce(function) do |string,regex|
        string.sub(regex, '')
      end.capitalize
    end
  end

  def others_in_borough
    Person.where(borough_id: borough_id, id: {'$ne' => id})
  end

  def latest_activity(source)
    activities.where(source: source).sort(:published_at.desc).first
  end

  def tel
    @tel ||= addresses.detect{|x| x.tel}.andand.tel
  end

  def fax
    @fax ||= addresses.detect{|x| x.fax}.andand.fax
  end

  def source_id
    source_url[/\d+\z/]
  end

  def url
    "http://ville.montreal.qc.ca/portal/page?_pageid=5798,85809754&_dad=portal&_schema=PORTAL&id=#{source_id}"
  end

  def wikipedia_url
    "http://fr.wikipedia.org/wiki/#{wikipedia[I18n.locale]}" if wikipedia[I18n.locale]
  end

  def biography_text
    biography[I18n.locale]
  end

  def web_url
    web[I18n.locale]
  end

  def add_subscriber(email)
    email.downcase!
    address = Mail::Address.new email
    if (address.address == email && address.domain && address.__send__(:tree).domain.dot_atom_text.elements.size > 1)
      unless subscribers.include? email
        push subscribers: email
      end
    else
      raise InvalidEmail
    end
  end

private

  def set_attributes
    if name
      self.slug = name.slug.sub(/-.+-/, '-')
      self.first_name = name[/\A\S+/]
      self.last_name = name[/\S+\z/]
    end
    if party
      self.party_slug = party.slug
      self.party_name = party.name
    end
    if borough
      self.borough_name = borough.name
      self.borough_slug = borough.slug
    end
  end
end
