# coding: utf-8
require 'time'

class Activity
  GOOGLE_NEWS = 'news.google.ca'

  # http://blog.slashpoundbang.com/post/12975232033/google-news-search-parameters-the-missing-manual
  GOOGLE_NEWS_URL = 'http://news.google.ca/news?'
  GOOGLE_NEWS_PARAMS = {
    pz:      1,
    output:  'rss',
    hl:      'fr',    # host language
    num:     100,
    scoring: 'n',     # sort by date (newest first)
    ned:     'fr_ca', # Édition Canada Français
    as_drrb: 'q',
    as_qdr:  'a',     # anytime
    # geo and location don't retrieve identical results, though location gets
    # results for more councillors. geo gets longer titles.
    # * geo=Québec
    # * geo=Montréal
    # * location:Québec
    # * location:Montréal
  }

  def image
    case source
    when GOOGLE_NEWS
      extra[:image]
    end
  end

  def guid
    case source
    when GOOGLE_NEWS
      extra[:guid]
    end
  end

  def self.google_news(person)
    activity = person.latest_activity(GOOGLE_NEWS)
    source = person.sources.find_by(name: GOOGLE_NEWS) || person.sources.build(name: GOOGLE_NEWS)

    q = []
    if source.extra[:as_oq]
      q << source.extra[:as_oq].map{|x| %("#{x}")}.join(' OR ')
    elsif source.extra.has_key?(:q)
      q << %("#{source.extra[:q]}")
    else
      q << %("#{person.name}")
    end
    q += source.extra[:as_eq].map{|x| %(-"#{x}")} if source.extra[:as_eq].present?
    q << 'location:Québec'
    q = q.join ' '

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
    # @todo Feedzirra is pulling in duplicates. Rely on guid instead.
    if Fixnum === feed
      Rails.logger.warn tmp.feed_url
    elsif feed.new_entries.present?
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
