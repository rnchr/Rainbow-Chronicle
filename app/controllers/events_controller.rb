class EventsController < ApplicationController
  respond_to :html
  
  def index
    if params[:zip].present?
        @all_events = Event.near(params[:zip], 15, :order => :distance)
        @city = Geocoder.search(params[:zip])
      else
        @city = Geocoder.search("Eiffel Tower")
        @all_events = Event.near([42.413454,-71.1088269], 15)
      end
      @events = @all_events.page(params[:page]).per(10)
      @json = @all_events.to_gmaps4rails
  end

  def show
    @event = Event.find(params[:id])
    @ratings = @event.ratings.map do |r|
      rating_helper r
    end
    @rating = @event.ratings.new 
    @rating_questions = Rating.where(:for => "events")
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
