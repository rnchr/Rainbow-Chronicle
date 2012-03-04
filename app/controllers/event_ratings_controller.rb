class EventRatingsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  
  respond_to :html
  
  def new
    @event_rating = event.ratings.new
    respond_with [event, @event_rating]
  end
  
  def create
    @event_rating = event.ratings.new(params[:event_rating])
    respond_with [event, @event_rating] do |format|
      format.html do
        if @event_rating.save
          flash[:notice] = 'Your rating was saved.'
          redirect_to event_path(event)
        else
          flash[:notice] = "there was an error"
          render 'new'
        end
      end
    end
  end
  
  def edit
    @event_rating = event.ratings.find(params[:id])
    
    respond_with [event, @event_rating]
  end
  
  def update
    @event_rating = event.ratings.find(params[:id])
    
    update_was_successful = @event_rating.update_attributes(params[:event_rating])
    if update_was_successful
      redirect_to events_path(event, :notice => "Your edit was saved.")
    else
      render 'edit'
    end
  end
  
  private
  
  def event
    @event ||= Event.find(params[:event_id])
  end
end