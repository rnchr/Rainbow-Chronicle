class NewsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create, :update, :edit, :destroy]
  before_filter :set_active
  
  authorize_resource
  def popular
    @news = News.popular.page(params[:page]).per(10)
  end
  
  def controversial
    @news = News.controversial.page(params[:page]).per(10)
  end

  def index
    @news = News.latest.page(params[:page]).per(10)
    @fp = News.last_founders_post.first
  end

  def show
    @news = News.find(params[:id])
    @news.views ||= 0
    @news.views +=1
    @news.save
    @comments = @news.comments
    @comment = Comment.new
  end

  def new
    @news = News.new
  end


  def edit
    @news = News.find(params[:id])
  end

  def create
    @news = News.new(params[:news])
    @news.founders_post = (params[:founders_post] and current_user.admin?)
    @news.user = current_user
    if @news.save
      redirect_to @news, notice: 'News was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @news = News.find(params[:id])

    respond_to do |format|
      if @news.update_attributes(params[:news])
        format.html { redirect_to @news, notice: 'News was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @news = News.find(params[:id])
    @news.destroy

    respond_to do |format|
      format.html { redirect_to news_index_url }
      format.json { head :no_content }
    end
  end
  
  private
  def set_active
    @active = "News"
  end
  
end
