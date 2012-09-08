require 'iconv'

class BoroughsController < ApplicationController
  def index
    @boroughs = Borough.fields(:name, :slug).all

    respond_to do |format|
      format.html
      format.json { render json: @boroughs }
    end
  end

  def show
    @borough = Borough.find_by_slug!(params[:id])
    @activities = Activity.where(borough_id: @borough.id).sort(:published_at.desc).limit(40)
    # @todo import events in a Rake task, assign events to boroughs
    @events = RiCal.parse(Iconv.conv('UTF-8', 'ISO-8859-1', open('http://murmitoyen.com/events/link/iCalendar.php?gID=234').read))[0].events

    respond_to do |format|
      format.html
      format.json { render json: @borough }
      format.atom { head :no_content if @activities.empty? }
    end
  rescue MongoMapper::DocumentNotFound, BSON::InvalidStringEncoding
    respond_to do |format|
      format.html { render file: Rails.root.join('public', '404.html'), status: :not_found }
      format.json { head :not_found }
      format.atom { head :not_found }
    end
  end
end
