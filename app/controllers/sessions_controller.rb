class SessionsController < ApplicationController

  before_action :require_user_logged_out, only: [:new, :create]

  def new
  end
  
  def create
    user = User.find_by(email: params[:email])
    
    if user.present? && user.authenticate(params[:password]) # authenticate method comes from users has_secure_password
      session[:user_id] = user.id

      flash[:primary] = "Welcome back!"
      redirect_to me_path
    else
      flash.now[:danger] = "Invalid email or password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:primary] = "Logged out. Byebye!"
    redirect_to root_path
  end
end
