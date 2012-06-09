class EventsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create]
  before_filter :authenticate_and_check_permission, :only => [:update, :edit, :destroy]
  before_filter :set_active
  
  def index
    set_all_index_vars
  end

  def show
    set_show_vars
    @rating_questions = Rating.where(:for => 'events')
  end

  def popular
    set_popular_vars
    render 'shared/popular'
  end
  
  def unsafe
    set_unsafe_vars
    render 'shared/popular'
  end

  def new
    @event = Event.new
    set_category_vars EventType
  end

  def edit
    @event = Event.find(params[:id])
    set_category_vars EventType
    
  end

  def create
    @event = Event.new(params[:event])
    unless params[:categories].nil?
      @event.tags << params[:categories].collect {|c| EventType.find(c) }
    end
    @event.user = current_user
    if @event.save
      current_user.add_stars(@event.city, @event.state, 2)
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @event = Event.find(params[:id])
    unless params[:categories].nil?
      @event.tags << params[:categories].collect {|c| EventType.find(c) }
    end
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
  def klass; @klass = Event; end
  def set_active; @active = "Event"; end

end
