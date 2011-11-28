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

  def timestamp(timestamp)
    if timestamp.utc.to_date == Date.today
      %(<span class="timeago" title="#{timestamp.iso8601}">#{timestamp.strftime '%-d %b'}</span>).html_safe
    elsif timestamp > Time.now - 31_556_926
      %(<span title="#{timestamp.iso8601}">#{timestamp.strftime '%-d %b'}</span>).html_safe
    else
      %(<span title="#{timestamp.iso8601}">#{timestamp.strftime '%-d %b %y'}</span>).html_safe
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
