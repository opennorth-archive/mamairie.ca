module ApplicationHelper
  include Twitter::Autolink

  def title
    t "#{controller.controller_name}.#{controller.action_name}.title"
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
end
