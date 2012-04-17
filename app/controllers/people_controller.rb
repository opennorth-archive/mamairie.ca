class PeopleController < ApplicationController
  # GET /people
  # GET /people.json
  def index
    @people = Person.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @people }
    end
  end

  # GET /people/1
  # GET /people/1.json
  def show
    @person = Person.find_by_slug!(params[:id])
    @activities = @person.activities.sort(:published_at.desc).limit(50)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @person }
      format.atom { head :no_content if @activities.empty? }
    end
  end

  def subscribe
    @person = Person.find(params[:id])
    if params[:email].blank?
      flash.alert = t('subscribe.blank')
    else
      begin
        @person.add_subscriber(params[:email])
        flash.notice = t('subscribe.success')
      rescue Person::InvalidEmail
        flash.alert = t('subscribe.invalid')
      end
    end
    redirect_to person_path(id: @person.slug)
  end
end
