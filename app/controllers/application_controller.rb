class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def authenticate_api_request
    token = request.headers['Authorization']
    @current_user = User.find_by(authentication_token: token)

    unless @current_user
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end

  def html_request?
    request.format.symbol == :html
  end

  def json_request?
    request.format.symbol == :json
  end
end
