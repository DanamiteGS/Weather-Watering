class PasswordResetsController < ApplicationController

  before_action :require_user_logged_out, only: [:new, :create]

  def new
  end

  def create
    if params[:email].present?
      @user = User.find_by(email: params[:email])

      if @user.present?
        PasswordResetMailer.with(user: @user).reset.deliver_later
      end

      flash[:primary] = "We have sent instructions to change your password to #{params[:email]} Please check both your inbox and spam folder"
      redirect_to password_reset_path
    else
      flash.now[:danger] = "Please enter your email address!"
      render :new
    end
  end

  def edit
    @user = User.find_signed!(params[:token], purpose: "password_reset")
    
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    flash.now[:danger] = "Your token has expired. Please try again!"
    redirect_to password_reset_path
  end

  def update
    @user = User.find_signed!(params[:token], purpose: "password_reset")

    if @user.update(password_params)
      flash[:primary] = "Your password was reset successfully! Please login."
      redirect_to login_path
    else
      render :edit
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
