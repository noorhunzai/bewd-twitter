class SessionsController < ApplicationController
  def create
    user = User.find_by(username: params[:user][:username])
  
    if user&.authenticate(params[:user][:password])
      session = user.sessions.create
      render json: { session: session, success: true }
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end
  
  def authenticated
    session = Session.find_by(token: cookies[:twitter_session_token])
  
    if session
      render json: { authenticated: true, user: session.user }, status: :ok
    else
      render json: { authenticated: false }, status: :ok
    end
  end
  def destroy
    session = Session.find_by(token: cookies[:twitter_session_token])
  
    if session
      session.destroy
      render json: { success: true }
    else
      render json: { error: 'Session not found' }, status: :not_found
    end
  end
  
end
