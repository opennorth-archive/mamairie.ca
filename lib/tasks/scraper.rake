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
    # https://github.com/technoweenie/faraday/wiki/Setting-up-SSL-certificates
    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    Person.where(photo_src: {'$exists' => true}).each do |person|
      unless (Faraday.head(person.photo.url).status rescue false)
        person.remote_photo_url = person.photo_src
        person.save!
      end
    end
  end

  # Run on occasion
  desc 'Import Wikipedia content'
  task :wikipedia => :environment do
    # @todo
  end

  desc 'Import Twitter tweets'
  task :twitter => :environment do
    require 'time'

    # @note OAuth calls raise limit to 350 per hour: https://dev.twitter.com/docs/rate-limiting
    # @note Apigee supposedly has higher rate limits
    Twitter.configure do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      config.oauth_token = ENV['TWITTER_OAUTH_TOKEN']
      config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
    end
    Twitter.gateway = ENV['APIGEE_TWITTER_API_ENDPOINT']

    Person.where(twitter: {'$exists' => true}).sort(:name.asc).all.each do |person|
      activity = person.activities.where(source: Activity::TWITTER).sort(:published_at.desc).first

      since_id = activity ? activity.extra[:id_str] : 1

      # @note We can paginate at most 3,200 tweets: https://dev.twitter.com/docs/things-every-developer-should-know
      1.upto(16) do |page|
        # @todo if import is interrupted due to rate limit, rest of history will not be imported
        if Twitter.rate_limit_status.remaining_hits.zero?
          raise "No remaining Twitter hits. Reset in #{Twitter.reset_time_in_seconds} seconds."
        end

        begin
          tweets = Twitter.user_timeline(person.twitter, count: 200, since_id: since_id, page: page)
        rescue StandardError => e
          puts "Retrying in 2... #{e}"
          sleep 2
          retry
        end

        break if tweets.empty?

        tweets.each do |tweet|
          person.activities.create!({
            source:       Activity::TWITTER,
            party_id:     person.party_id,
            borough_id:   person.borough_id,
            district_id:  person.district_id,
            url:          "http://twitter.com/#{tweet.attrs['user']['screen_name']}/status/#{tweet.attrs['id_str']}",
            body:         tweet.attrs['text'],
            published_at: Time.parse(tweet.attrs['created_at']),
            extra: {
              name:              tweet.attrs['user']['name'],
              screen_name:       tweet.attrs['user']['screen_name'],
              profile_image_url: tweet.attrs['user']['profile_image_url'],
              id_str:            tweet.attrs['id_str'],
            },
          })
        end
      end
    end
  end

  desc 'Import Google News articles'
  task :google_news => :environment do
    include ActionView::Helpers

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
      source = person.sources[Activity::GOOGLE_NEWS] || person.sources.build(name: Activity::GOOGLE_NEWS)
      activity = person.activities.where(source: Activity::GOOGLE_NEWS).sort(:published_at.desc).first
      q = source.extra.has_key?(:q) ? source.extra[:q] : person.name
      q = [%("#{q}"), 'location:Québec', source.extra[:as_eq].andand.map{|x| %(-"#{x}")}].flatten.compact.join(' ')

      # https://gist.github.com/132671
      tmp = Feedzirra::Parser::RSS.new
      tmp.feed_url = GOOGLE_NEWS_URL + GOOGLE_NEWS_PARAMS.merge(q: q).to_param
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
          publisher, body = doc.css('font[size="-1"]')[0..1].map(&:text)

          person.activities.create!({
            source:       Activity::GOOGLE_NEWS,
            party_id:     person.party_id,
            borough_id:   person.borough_id,
            district_id:  person.district_id,
            url:          entry.url,
            body:         body,
            published_at: entry.published,
            extra: {
              publisher: publisher,
              title:     entry.title.sub(/ - #{Regexp.escape(publisher)}/, ''),
              image:     doc.at_css('img').andand[:src],
              guid:      entry.entry_id,
            }
          })
        end
      end
    end
  end
end
