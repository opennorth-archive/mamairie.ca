# coding: utf-8
require 'iconv'

Popolo::AreasController.class_eval do
  def show
    @area = Popolo::Area.find_by(slug: params[:id])
    @activities = @area.events.sort(issued_at: -1).limit(40)
    # @todo import events in a Rake task, assign events to boroughs, avoids timeout error
    # @todo RiCal::InvalidTimezoneIdentifier: "Eastern Standard Time" is not known to the tzinfo database
    @events = RiCal.parse_string(Iconv.conv('UTF-8', 'ISO-8859-1', open('http://murmitoyen.com/events/link/iCalendar.php?gID=234').read))[0].events
    show!
  end

protected

  def collection
    @areas ||= end_of_association_chain.without :postal_codes
  end
end
