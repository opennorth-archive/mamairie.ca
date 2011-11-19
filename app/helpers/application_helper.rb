module ApplicationHelper
  include Twitter::Autolink

  def title
    t "#{controller.controller_name}.#{controller.action_name}.title"
  end
end
