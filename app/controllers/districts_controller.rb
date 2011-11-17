class DistrictsController < ApplicationController
  # GET /districts
  # GET /districts.json
  def index
    @districts = District.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @districts }
    end
  end

  # GET /districts/1
  # GET /districts/1.json
  def show
    @district = District.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @district }
    end
  end

  # GET /districts/new
  # GET /districts/new.json
  def new
    @district = District.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @district }
    end
  end

  # GET /districts/1/edit
  def edit
    @district = District.find(params[:id])
  end

  # POST /districts
  # POST /districts.json
  def create
    @district = District.new(params[:district])

    respond_to do |format|
      if @district.save
        format.html { redirect_to @district, notice: 'District was successfully created.' }
        format.json { render json: @district, status: :created, location: @district }
      else
        format.html { render action: "new" }
        format.json { render json: @district.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /districts/1
  # PUT /districts/1.json
  def update
    @district = District.find(params[:id])

    respond_to do |format|
      if @district.update_attributes(params[:district])
        format.html { redirect_to @district, notice: 'District was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @district.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /districts/1
  # DELETE /districts/1.json
  def destroy
    @district = District.find(params[:id])
    @district.destroy

    respond_to do |format|
      format.html { redirect_to districts_url }
      format.json { head :ok }
    end
  end
end
