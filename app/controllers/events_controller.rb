class EventsController < ApplicationController
  respond_to :html
  
  def index
    if params[:zip].present?
      @events = Event.near(params[:zip], 50, :order => :distance)
      @city = Geocoder.search(params[:zip])
    else
      @city = Geocoder.search("Eiffel Tower")
      @events = Event.near("02155")
    end
    @json = @events.to_gmaps4rails
  end

  def show
    @event = Event.find(params[:id])
    @event_rating = @event.ratings.new
  end

  def new
    @event = Event.new
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(params[:event])

    if @event.save
      redirect_to @event, notice: 'Event was successfully created.' 
    else
      render action: "new"
    end
  end

  def update
    @event = Event.find(params[:id])

    if @event.update_attributes(params[:event])
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render action: "edit"
    end
    
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    
    redirect_to events_url
  end
end
