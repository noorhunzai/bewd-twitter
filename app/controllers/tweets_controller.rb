class TweetsController < ApplicationController
  def create
    session = Session.find_by(token: cookies[:twitter_session_token])
    user = session&.user

    if user
      tweet = user.tweets.new(tweet_params)

      if tweet.save
        render json: { tweet: tweet_data(tweet) }, status: :created
      else
        render json: { error: tweet.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Session not found' }, status: :unauthorized
    end
  end

  def destroy
    session = Session.find_by(token: cookies[:twitter_session_token])
    user = session&.user
    tweet = Tweet.find_by(id: params[:id])

    if user && tweet && tweet.user == user
      tweet.destroy
      render json: { success: true }, status: :ok
    elsif !tweet
      render json: { error: 'Tweet not found' }, status: :not_found
    else
      render json: { success: false, error: 'You are not authorized to delete this tweet' }, status: :unauthorized
    end
  end

  def index
    tweets = Tweet.includes(:user).all
    render json: { tweets: tweets.map { |tweet| tweet_data(tweet) } }
  end

  def index_by_user
    user = User.find_by(username: params[:username])
  
    if user
      tweets = user.tweets.includes(:user).select(:id, :message, :user_id).map { |tweet| tweet_data(tweet) }
      render json: { tweets: tweets }, status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end
  
  
  

  private

  def tweet_data(tweet)
    {
      id: tweet.id,
      username: tweet.user.username,
      message: tweet.message
    }
  end

  def tweet_params
    params.require(:tweet).permit(:message)
  end
end
