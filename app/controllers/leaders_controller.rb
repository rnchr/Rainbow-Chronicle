class LeadersController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create]
  before_filter :authenticate_and_check_permission, :only => [:update, :edit, :destroy]
  before_filter :set_active

  def index
     set_all_index_vars
  end

  def show
    set_show_vars
    @rating_questions = Rating.where(:for => "leaders")
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
    @leader = Leader.new
  end

  def edit
    @leader = Leader.find(params[:id])
  end

  def create
    leader = Leader.new(params[:leader])
    if leader.save
      redirect_to leader
    else
      render action: 'new'
    end
  end

  def update
    @leader = Leader.find(params[:id])
    if @leader.update_attributes(params[:leader])
      redirect_to @leader, notice: 'Leader was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @leader = Leader.find(params[:id])
    @leader.destroy

    redirect_to leaders_url
  end
  
  private
  def klass; @klass = Leader; end
  def set_active
    @active = "Leader"
  end
  
end
