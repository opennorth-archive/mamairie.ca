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
    @person = Person.find_by_slug(params[:id])
    @activities = @person.activities.sort(:published_at.desc).limit(10)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @person }
    end
  end
end
