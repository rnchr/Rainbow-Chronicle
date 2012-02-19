class LeadersController < ApplicationController
  # GET /leaders
  # GET /leaders.json
  def index
    @leaders = Leader.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @leaders }
    end
  end

  # GET /leaders/1
  # GET /leaders/1.json
  def show
    @leader = Leader.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @leader }
    end
  end

  # GET /leaders/new
  # GET /leaders/new.json
  def new
    @leader = Leader.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @leader }
    end
  end

  # GET /leaders/1/edit
  def edit
    @leader = Leader.find(params[:id])
  end

  # POST /leaders
  # POST /leaders.json
  def create
    @leader = Leader.new(params[:leader])

    respond_to do |format|
      if @leader.save
        format.html { redirect_to @leader, notice: 'Leader was successfully created.' }
        format.json { render json: @leader, status: :created, location: @leader }
      else
        format.html { render action: "new" }
        format.json { render json: @leader.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /leaders/1
  # PUT /leaders/1.json
  def update
    @leader = Leader.find(params[:id])

    respond_to do |format|
      if @leader.update_attributes(params[:leader])
        format.html { redirect_to @leader, notice: 'Leader was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @leader.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leaders/1
  # DELETE /leaders/1.json
  def destroy
    @leader = Leader.find(params[:id])
    @leader.destroy

    respond_to do |format|
      format.html { redirect_to leaders_url }
      format.json { head :no_content }
    end
  end
end
