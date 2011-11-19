# coding: utf-8
class BoroughsController < ApplicationController
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
      :value => 20_000,
    }.merge(row)
  end

  # GET /boroughs
  # GET /boroughs.json
  def index
    @boroughs = Borough.fields(:name, :slug).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @boroughs }
    end
  end

  # GET /boroughs/1
  # GET /boroughs/1.json
  def show
    @borough = Borough.find(params[:id])
    @rows = DATA

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @borough }
    end
  end
end
