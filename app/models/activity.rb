require 'time'

class Activity
  TWITTER = 'twitter.com'
  GOOGLE_NEWS = 'news.google.ca'

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

  include MongoMapper::Document
  belongs_to :person
  belongs_to :party
  belongs_to :borough
  belongs_to :district

  key :body, String, required: true
  key :url, String, required: true
  key :published_at, Time, required: true
  key :source, String, required: true
  key :extra, Hash
  timestamps!

  ensure_index :source
  ensure_index [[:published_at, -1]]

  def publisher_url
    case source
    when TWITTER
      "http://twitter.com/#{extra[:screen_name]}"
    end
  end

  def image
    case source
    when TWITTER
      extra[:profile_image_url]
    when GOOGLE_NEWS
      extra[:image]
    end
  end

  def self.twitter(person)
    activity = person.latest_activity(TWITTER)
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

  def self.google_news(person)
    activity = person.latest_activity(GOOGLE_NEWS)
    source = person.sources[GOOGLE_NEWS] || person.sources.build(name: GOOGLE_NEWS)
    q = [
      %("#{source.extra.has_key?(:q) ? source.extra[:q] : person.name}"),
      source.extra[:as_eq].andand.map{|x| %(-"#{x}")},
      'location:Québec',
    ].flatten.compact.join(' ')

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
