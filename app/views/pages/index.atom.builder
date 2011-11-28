atom_feed(:language => locale) do |feed|
  feed.title t('.feed.title')
  feed.author do
    feed.name t('.feed.author')
  end
  feed.updated(@activities.first.published_at)

  @activities.each do |activity|
    feed.entry(activity, updated: activity.published_at, published: activity.published_at, url: activity.url) do |entry|
      case activity.source
      when Activity::TWITTER
        entry.author do
          entry.name(activity.person.name)
        end
        entry.summary(Twitter::Autolink.auto_link(activity.body), type: 'html')
        entry.title(activity.person.name)
      when Activity::GOOGLE_NEWS
        entry.author do
          entry.name(activity.extra[:publisher])
        end
        entry.summary(activity.body)
        entry.title(activity.extra[:title])
      end
    end
  end
end
