class AuthenticationsController < ApplicationController
  def index
  end

  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
#    render :text => omniauth.to_yaml
#=begin
    if authentication
      User.confirm_or_add_image(omniauth, authentication.user.id)
      if omniauth['provider'] == 'facebook'
        User.update_token(omniauth, authentication.user.id)
        session[:fblogin]="yes"
      end
      flash[:notice] = "Signed In Successfully"      
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      if omniauth['provider'] == 'facebook'
        User.update_token(omniauth, current_user.id)
        session[:fblogin]="yes"
      end
      flash[:notice] = "Authentication successful."
      redirect_to root_path  
    else
      user=User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Account created successfully"
        session[:fblogin]="yes"
        if session[:fblogin] == "yes"
          current_user.announce_signup
        end
        sign_in(:user, user)
        redirect_to edit_user_registration_url
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url  
      end
    end  
#=end
  end

  def destroy
  end
end
