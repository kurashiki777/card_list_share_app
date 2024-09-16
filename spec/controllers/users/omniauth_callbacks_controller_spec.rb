require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  describe 'LINE' do
    before do
      request.env['devise.mapping'] = Devise.mappings[:user]
      OmniAuth.config.mock_auth[:line] = OmniAuth::AuthHash.new({
        provider: 'line',
        uid: '123545',
        info: {
          email: 'test@example.com',
          name: 'Test User'
        }
      })
    end

    it 'successfully signs in the user using LINE' do
      get :line

      expect(session[:user_id]).not_to be_nil
      expect(response).to redirect_to(root_path)
    end
  end
end