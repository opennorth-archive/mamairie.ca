# coding: utf-8
module ApplicationHelper
  def title
    params = {}
    if @person
      params[:name] = @person.name
    elsif @borough
      params[:name] = @borough.name
    end
    t "#{controller.controller_name}.#{controller.action_name}.title", params
  end

  # Open Graph tags
  def og_title
    if @person
      @person.name
    elsif @borough
      @borough.name
    else
      'Ma Mairie'
    end
  end

  def og_type
    if @person
      'politician'
    elsif @borough
      'city'
    else
      'website'
    end
  end

  def og_image
    if @person
      'http:' + @person.photo.large.url
    else
      root_url.chomp('/') + image_path(t('logo.medium'))
    end
  end

  def og_description
    t "layouts.#{controller.send :_layout}.description"
  end

  # Feeds
  def escape_url(url)
    URI.escape url, Regexp.new("[^#{URI::REGEXP::PATTERN::UNRESERVED}]", false, 'N')
  end

  # Social
  def twitter_url(screen_name)
    "http://twitter.com/#{screen_name}"
  end
  def twitter_button(screen_name, options = {})
    link_to t('social.twitter', name: screen_name), twitter_url(screen_name), {'class' => 'twitter-follow-button', 'data-lang' => locale}.merge(options)
  end

  # Other
  def timestamp(timestamp)
    if timestamp.utc.to_date == Date.today
      %(<abbr class="timestamp timeago" title="#{timestamp.iso8601}">#{timestamp.strftime '%-d %b'}</abbr>).html_safe
    elsif timestamp > Time.now - 31_556_926
      %(<abbr class="timestamp" title="#{timestamp.strftime '%H:%M, %-d %b'}">#{timestamp.strftime '%-d %b'}</abbr>).html_safe
    else
      %(<abbr class="timestamp" title="#{timestamp.strftime '%H:%M, %-d %b %y'}">#{timestamp.strftime '%-d %b %y'}</abbr>).html_safe
    end
  end

  def web_url_text(person)
    # @note May raise an error if regular expression doesn't match
    case person.web_url[%r{\Ahttp://(?:www\.)?([a-z0-9-]+)\.(?:com|org)\b}, 1].downcase
    when 'projetmontreal'
      t('links.projetmontreal', name: person.name)
    when 'unionmontreal'
      t('links.unionmontreal', name: person.name)
    when 'visionmtl'
      t('links.visionmtl', name: person.name)
    else
      t('links.personal', name: person.name)
    end
  end
end
