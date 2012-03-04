class LeadersController < ApplicationController
  # GET /leaders
  # GET /leaders.json
  def index
     if params[:zip].present?
        @all_leaders = Leader.near(params[:zip], 15, :order => :distance)
        @city = Geocoder.search(params[:zip])
      else
        @city = Geocoder.search("Eiffel Tower")
        @all_leaders = Leader.near([42.413454,-71.1088269], 15)
      end
      @leaders = @all_leaders.page(params[:page]).per(10)
      @json = @all_leaders.to_gmaps4rails
  end

  # GET /leaders/1
  # GET /leaders/1.json
  def show
    @leader = Leader.find(params[:id])
    @ratings = @leader.ratings.map do |r|
      rating_helper r
    end
    @rating = @leader.ratings.new 
    @rating_questions = Rating.where(:for => "leaders")
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
