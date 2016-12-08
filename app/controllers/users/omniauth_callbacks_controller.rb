class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  require 'json'
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb
    @existingUser = User.find_by(uid: request.env["omniauth.auth"].uid).freeze
    if !$conversation_id.nil?
      @user = User.from_omniauth(request.env["omniauth.auth"], $conversation_id)
    else
      @user = User.from_omniauth(request.env["omniauth.auth"])
    end

    if @existingUser.nil? && $conversation_id.nil?
      redirect_to pages_talk_to_christopher_path
    else

      if @user.persisted? 
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url if current_user.nil?
      end
    end
  end

  def failure
    redirect_to root_path
  end
end