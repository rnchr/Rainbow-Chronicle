class ReportsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_post, :except => [:destroy]
  
  def new
    @report = Report.new
  end
  
  def create
    reasons = %w{inappropriate inaccurate other}

    @report = Report.new
    @report.item_id = params[:id]
    @report.user = current_user
    @report.post_type = params[:type]
    @report.report_type = params[:report][:report_type]
    @report.report_content = params[:report][:report_content]
    @report.ip_address = request.remote_ip
    
    if @report.save
      puts "SAVED"
      if @type.eql? Comment
        redirect_to @post.news, notice: "Thanks for letting us know."
      else
        redirect_to @post, notice: "Thanks for letting us know."
      end
    else
      render action: 'new'
    end
  end
  
  # only admins can delete reports
  def destroy
    report = Report.find params[:id]
    if current_user.admin?
      report.destroy
    end
    redirect_to root
  end
  
  private
  def load_post
    @type = case params[:type]
    when 'place'
      Place
    when 'event'
      Event
    when 'leader'
      Leader
    when 'news'
      News
    when 'comment'
      Comment
    else
      not_found
    end
    @post = @type.find(params[:id])
  end
end