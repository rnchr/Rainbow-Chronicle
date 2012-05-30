class AuthenticationsController < ApplicationController
  def index
  end

  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      #render :text => omniauth.to_yaml
      User.confirm_or_add_image(omniauth, authentication.user.id)
      flash[:notice] = "Signed In Successfully"      
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "Authentication successful."
      redirect_to root_path  
    else
      user=User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Account created successfully"
        session[:fblogin]="yes"
        sign_in(:user, user)
        redirect_to edit_user_registration_url
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url  
      end
    end  
  end

  def destroy
  end
end
