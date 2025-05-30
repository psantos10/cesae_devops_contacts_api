class UsersController < ApplicationController
  skip_before_action :authenticate_user, only: [ :create, :login ]

  def create
    @user = User.new(user_params)

    if @user.save
      render json: {
        user: { id: @user.id, email: @user.email },
        token: @user.auth_token
      }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      @user.regenerate_auth_token if params[:regenerate_token]
      render json: {
        user: { id: @user.id, email: @user.email },
        token: @user.auth_token
      }
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def me
    render json: {
      user: { id: current_user.id, email: current_user.email }
    }
  end

  def logout
    current_user.regenerate_auth_token
    head :no_content
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
