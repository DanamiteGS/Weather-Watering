class PasswordsController < ApplicationController
  
  before_action :require_user_logged_in!

  def edit
  end

  def update
    respond_to do |format|
      if password_is_present
     
        if Current.user.update(password_params)
          format.html { redirect_to me_path, notice: "Password updated!" }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      else
        Current.user.errors.add(:password, "is empty!")
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def password_is_present
    return unless params[:password].present? && params[:password_confirmation].present?
  end
end
