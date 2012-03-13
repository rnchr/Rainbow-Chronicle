class UsersController < ApplicationController
  before_filter :verify_admin
  
  def destroy
    user = User.find params[:id]
    user.destroy
    
    redirect_to :admin
  end
  
  def make_admin
    user = User.find params[:id]
    user.admin = 1
    user.save
    redirect_to :admin
  end
end