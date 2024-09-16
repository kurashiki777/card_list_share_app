class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def line
    # binding.pry
    Rails.logger.debug "Session state before callback: #{session[:omniauth_state]}"
    Rails.logger.debug "Callback state: #{params[:state]}"
    logger.debug "Request environment: #{request.env.inspect}"
    basic_action
  end

  def failure
    Rails.logger.error "OmniAuth callback params: #{params.inspect}"
    Rails.logger.error "OmniAuth error: #{request.env['omniauth.error.type']}"
    Rails.logger.error "OmniAuth full error: #{request.env['omniauth.error'].inspect}"
    Rails.logger.error "OmniAuth failure: #{request.env['omniauth.error'].inspect}"
    Rails.logger.debug "Session state: #{session[:omniauth_state]}"
    Rails.logger.debug "Callback state: #{params[:state]}"
    # binding.pry
    super
  end
  
  private
  
  def basic_action
    @omniauth = request.env["omniauth.auth"]
  
    if @omniauth.present?
      @profile = User.find_or_initialize_by(provider: @omniauth["provider"], uid: @omniauth["uid"])
  
      if @profile.email.blank?
        email = @omniauth["info"]["email"] ? @omniauth["info"]["email"] : "#{@omniauth["uid"]}-#{@omniauth["provider"]}@example.com"
        @profile = current_user || User.create!(provider: @omniauth["provider"], uid: @omniauth["uid"], email: email, name: @omniauth["info"]["name"], password: Devise.friendly_token[0, 20])
      end
  
      @profile.set_values(@omniauth)
      sign_in(:user, @profile)
    end
  
    flash[:notice] = "ログインしました"
    redirect_to cards_path 
  end

	# ダミーのemailアドレスを作成するメソッド
  def fake_email(uid, provider)
    "#{auth.uid}-#{auth.provider}@example.com"
  end
end
