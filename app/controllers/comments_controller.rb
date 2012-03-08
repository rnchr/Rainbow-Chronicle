class CommentsController < ApplicationController
  before_filter :authenticate_user!
  def create
    news = News.find(params[:news_id])
    comment = news.comments.new
    comment.user = current_user
    unless params[:comment][:body].blank?
      comment.body = params[:comment][:body]
    else
      redirect_to news, notice: "Comments can't be blank." and return
    end
    comment.ip_address = request.remote_ip
    comment.user_agent = request.headers["HTTP_USER_AGENT"]
    if comment.save
      redirect_to news
    else
      redirect_to news, notice: "Couldn't save your comment."
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    news = comment.news
    
    if comment.user.eql? current_user or current_user.admin?
      comment.destroy
      News.transaction do
        news.comment_count -= 1
        news.save
      end
      redirect_to news
    else
      redirect_to news
    end
  end
  
  def report
    comment = Comment.find(params[:id])
    comment.reported = 1
    comment.save

    redirect_to News.find(params[:news_id]), notice: "Comment has been reported."
  end
end