class BoroughsController < ApplicationController
  # GET /boroughs
  # GET /boroughs.json
  def index
    @boroughs = Borough.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @boroughs }
    end
  end

  # GET /boroughs/1
  # GET /boroughs/1.json
  def show
    @borough = Borough.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @borough }
    end
  end
end
