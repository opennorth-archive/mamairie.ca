# coding: utf-8
namespace :scraper do
  desc 'Add mayors and councillors'
  task :retrieve => :environment do
    require 'runner'
    Runner.new.run [
      'retrieve',
    ]
  end

  # Run on occasion
  desc 'Download photos of mayors and councillors'
  task :photos => :environment do
    require 'open-uri'
    Person.all.each do |person|
      filename = File.join Rails.root, 'app', 'assets', 'images', 'photos', "#{person.slug}.jpg"
      unless person.photo_url.nil? or File.exist? filename
        File.open(filename, 'wb') do |f|
          f.write open(person.photo_url).read
        end
      end
    end
  end

  # Run on occasion
  desc 'Import Wikipedia content'
  task :wikipedia => :environment do

  end

  desc 'Import Twitter tweets'
  task :twitter => :environment do

  end

  desc 'Import Google News articles'
  task :google_news => :environment do
    include ActionView::Helpers

    GOOGLE_NEWS_KEY = 'news.google.ca'
    GOOGLE_NEWS_URL = 'http://news.google.ca/news?'
    GOOGLE_NEWS_PARAMS = {
      pz:      1,
      output:  'rss',
      hl:      'fr',
      num:     100,
      scoring: 'n',
      ned:     'fr_ca',
      as_drrb: 'q',
      as_qdr:  'a',
      # geo and location don't retrieve identical results, though location gets
      # results for more councillors. geo gets longer titles.
      # * geo=Québec
      # * geo=Montréal
      # * location:Québec
      # * location:Montréal
    }

    Person.sort(:name.asc).all.each do |person|
      source = person.sources[GOOGLE_NEWS_KEY] || person.sources.build(name: GOOGLE_NEWS_KEY)
      activity = person.activities.where(source: GOOGLE_NEWS_KEY).sort(:published_at.desc).first
      q = source.extra.has_key?(:q) ? source.extra[:q] : person.name

      # https://gist.github.com/132671
      tmp = Feedzirra::Parser::RSS.new
      tmp.feed_url = GOOGLE_NEWS_URL + GOOGLE_NEWS_PARAMS.merge(q: %("#{q}" location:Québec)).to_param
      tmp.etag = source.etag
      tmp.last_modified = source.last_modified

      if activity
        entry = Feedzirra::Parser::RSSEntry.new
        entry.url = activity.url
        tmp.entries = [entry]
      end

      feed = Feedzirra::Feed.update(tmp)

      # @note feed.updated? doesn't guarantee new entries.
      if feed.new_entries.present?
        source.etag = feed.etag
        source.last_modified = feed.last_modified
        source.save!

        feed.new_entries.each do |entry|
          doc = Nokogiri::HTML(entry.summary, nil, 'utf-8')
          author, body = doc.css('font[size="-1"]')[0..1].map(&:text)

          person.activities.create!({
            title:        entry.title.sub(/ - #{Regexp.escape(author)}/, ''),
            author:       author,
            body:         body,
            url:          entry.url,
            photo_url:    doc.at_css('img').andand[:src],
            published_at: entry.published,
            source_id:    entry.entry_id,
            source:       GOOGLE_NEWS_KEY,
          })
        end
      end
    end
  end
end
