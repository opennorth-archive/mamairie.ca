# coding: utf-8
class PeopleController < ApplicationController
  DATA = [
    {
      :id => 'recreation',
      :title => "Arénas, piscines et pataugeoires",
      :description => "",
    },
    {
      :id => 'culture',
      :title => "Culture",
      :description => "",
    },
    {
      :id => 'proprete',
      :title => "Propreté et collectes des déchets et des matières recyclables",
      :description => "",
    },
    {
      :id => 'verdissement',
      :title => "Verdissement, parcs et espaces verts",
      :description => "",
    },
    {
      :id => 'entretien_routier',
      :title => "Entretien routier et déneigement",
      :description => "",
    },
  ].map! do |row|
    row = {
      :initial => 0,
      :minimum => -100_000,
      :maximum => 100_000,
      :step => 20_000,
    }.merge(row)
  end

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
    @person = Person.find(params[:id])
    @activities = Activity.where(:person_id => @person.id, :source => "twitter.com").sort(:published_at.desc).limit(10)
    @rows = DATA

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @person }
    end
  end
end
