require 'rails_helper'

RSpec.describe TweetsController, type: :controller do
  render_views

  describe 'POST /tweets' do
    it 'renders new tweet object' do
      user = FactoryBot.create(:user, username: 'testtest')
      session = user.sessions.create
      @request.cookies['twitter_session_token'] = session.token

      post :create, params: {
        tweet: {
          message: 'Test Message'
        }
      }

      expect(response.body).to include("\"tweet\":")
      expect(response.body).to include("\"username\":\"#{user.username}\"")
      expect(response.body).to include("\"message\":\"Test Message\"")
    end
  end

  describe 'GET /tweets' do
    it 'renders all tweets object' do
      user = FactoryBot.create(:user)
      tweet1 = FactoryBot.create(:tweet, user: user, message: 'Test Message 1')
      tweet2 = FactoryBot.create(:tweet, user: user, message: 'Test Message 2')

      get :index, format: :json

      tweets = [
        {
          id: tweet1.id,
          username: tweet1.user.username,
          message: 'Test Message 1'
        },
        {
          id: tweet2.id,
          username: tweet2.user.username,
          message: 'Test Message 2'
        }
      ]

      expect(response.body).to eq({ tweets: tweets }.to_json)
    end
  end

  describe 'DELETE /tweets/:id' do
    it 'renders success' do
      user = FactoryBot.create(:user)
      session = user.sessions.create
      @request.cookies['twitter_session_token'] = session.token

      tweet = FactoryBot.create(:tweet, user: user)

      delete :destroy, params: { id: tweet.id }

      expect(response.body).to eq({ success: true }.to_json)
      expect(Tweet.find_by(id: tweet.id)).to be_nil
    end

    it 'renders fails if not logged in' do
      user = FactoryBot.create(:user)
      tweet = FactoryBot.create(:tweet, user: user)

      delete :destroy, params: { id: tweet.id }

      expect(response.body).to eq({ success: false, error: 'You are not authorized to delete this tweet' }.to_json)
      expect(Tweet.find_by(id: tweet.id)).to be_present
    end
  end

  describe 'GET /users/:username/tweets' do
    it 'renders tweets by username' do
      user1 = FactoryBot.create(:user, username: 'user1')
      tweet1 = FactoryBot.create(:tweet, user: user1, message: 'Test Message 1')

      get :index_by_user, params: { username: user1.username }, format: :json

      tweets = [
        {
          id: tweet1.id,
          username: user1.username,
          message: 'Test Message 1'
        }
      ]

      expect(response.body).to eq({ tweets: tweets }.to_json)
    end
  end
end
