class PartiesController < ApplicationController
  def index
    @parties = Party.all

    respond_to do |format|
      format.html
      format.json { render json: @parties }
    end
  end

  def show
    @party = Party.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @party }
    end
  end
end
