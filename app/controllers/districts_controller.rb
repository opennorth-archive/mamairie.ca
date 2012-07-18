class DistrictsController < ApplicationController
  def index
    @districts = District.all

    respond_to do |format|
      format.html
      format.json { render json: @districts }
    end
  end

  def show
    @district = District.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @district }
    end
  end
end
