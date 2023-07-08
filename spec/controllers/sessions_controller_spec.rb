require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  render_views

  describe 'POST /sessions' do
    it 'renders new session object' do
      user = FactoryBot.create(:user, username: 'testtest', password: 'password')

      post :create, params: {
        user: {
          username: 'testtest',
          password: 'password'
        }
      }

      expect(JSON.parse(response.body)['session']).to be_present
      expect(JSON.parse(response.body)['success']).to eq(true)
    end
  end

  describe 'DELETE /sessions' do
    it 'renders success' do
      user = FactoryBot.create(:user)
      session = user.sessions.create
      @request.cookies['twitter_session_token'] = session.token

      delete :destroy

      expect(user.sessions.count).to eq(0)
      expect(response.body).to eq({ success: true }.to_json)
    end
  end
end
