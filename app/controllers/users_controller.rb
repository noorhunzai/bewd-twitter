class UsersController < ApplicationController
  def create
    user = User.new(user_params)

    if user.save
      render json: { user: { username: user.username, email: user.email } }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
