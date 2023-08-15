class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to movies_path
    end
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to movies_path, notice: 'Logged in!'
    else
      flash.now.alert = 'Invalid email or password'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    @current_user = nil
    redirect_to root_path, notice: 'Logged out!'
  end
end
