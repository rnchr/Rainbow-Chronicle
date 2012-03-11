class EventsController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, :only => [:new, :create, :update, :edit, :destroy]
  before_filter :set_active
  
  def index
    set_all_index_vars
  end

  def show
    set_show_vars
    @rating_questions = Rating.where(:for => 'events')
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
  
  private
  def klass; Event; end
  def set_active
    @active = "Event"
  end
end
