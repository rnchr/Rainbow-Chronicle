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
    set_category_vars LeaderType
  end

  def edit
    @leader = Leader.find(params[:id])
    set_category_vars LeaderType
    
  end

  def create
    @leader = Leader.new(params[:leader])
    unless params[:categories].nil?
      @leader.tags << params[:categories].collect {|c| LeaderType.find(c) }
    end 
    @leader.user = current_user
    if @leader.save
      current_user.add_stars(@leader.city, @leader.state, 2)
      if session[:fblogin] == "yes"
        link = root_url + "leaders/" + @leader.id.to_s
        current_user.announce_on_fb(@leader, "create", link)
      end
      session[:reviewalert]=true
      redirect_to @leader, notice: 'Leader was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @leader = Leader.find(params[:id])
    unless params[:categories].nil?
      @leader.tags << params[:categories].collect {|c| LeaderType.find(c) }
    end
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
