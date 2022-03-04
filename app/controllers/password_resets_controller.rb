class PasswordResetsController < ApplicationController

  before_action :require_user_logged_out, only: [:new, :create]

  def new
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user.present?
      PasswordResetMailer.with(user: @user).reset.deliver_later
    end
    redirect_to password_reset_path, notice: ("We have sent instructions to change your password to " + :email.to_s + ". Please check both your inbox and spam folder")
  end

  def edit
    @user = User.find_signed!(params[:token], purpose: "password_reset")
    
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to password_reset_path, alert: "Your token has expired. Please try again!"
  end

  def update
    @user = User.find_signed!(params[:token], purpose: "password_reset")

    if @user.update(password_params)
      redirect_to login_path, notice: "Your password was reset successfully! Please login."
    else
      render :edit
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
