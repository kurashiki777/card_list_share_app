require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }

    it 'successfully signs in the user and regenerates the session token' do
      post :create, params: { user: { email: user.email, password: user.password } }

      expect(session[:session_token]).not_to be_nil
      expect(response).to redirect_to(root_path)
    end
  end
end