class SessionsController < Devise::SessionsController
  def create
    # binding.pry
    super do |resource|
      session[:session_token] = SecureRandom.hex(64) # セッションの再生成
    end
  end
  
  def failure
    redirect_to root_path
  end
end