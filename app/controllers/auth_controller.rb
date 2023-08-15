class AuthController < ApplicationController
  skip_before_action :verify_authenticity_token

  def login
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      render json: { auth_token: user.authentication_token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
end
