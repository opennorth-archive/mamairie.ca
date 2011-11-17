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

  # GET /boroughs/new
  # GET /boroughs/new.json
  def new
    @borough = Borough.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @borough }
    end
  end

  # GET /boroughs/1/edit
  def edit
    @borough = Borough.find(params[:id])
  end

  # POST /boroughs
  # POST /boroughs.json
  def create
    @borough = Borough.new(params[:borough])

    respond_to do |format|
      if @borough.save
        format.html { redirect_to @borough, notice: 'Borough was successfully created.' }
        format.json { render json: @borough, status: :created, location: @borough }
      else
        format.html { render action: "new" }
        format.json { render json: @borough.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /boroughs/1
  # PUT /boroughs/1.json
  def update
    @borough = Borough.find(params[:id])

    respond_to do |format|
      if @borough.update_attributes(params[:borough])
        format.html { redirect_to @borough, notice: 'Borough was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @borough.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boroughs/1
  # DELETE /boroughs/1.json
  def destroy
    @borough = Borough.find(params[:id])
    @borough.destroy

    respond_to do |format|
      format.html { redirect_to boroughs_url }
      format.json { head :ok }
    end
  end
end
