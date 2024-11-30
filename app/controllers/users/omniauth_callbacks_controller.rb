class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :auth0

  def auth0
    # binding.pry
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    Rails.logger.debug("OmniAuth Auth Hash: #{request.env['omniauth.auth'].inspect}")
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      set_flash_message(:notice, :success, kind: "Auth0") if is_navigational_format?
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.auth0_data"] = request.env["omniauth.auth"].except(:extra) # Removing extra as it can overflow some session stores
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to destroy_user_session_path
  end
end