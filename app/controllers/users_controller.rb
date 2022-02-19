class UsersController < ApplicationController
  def new
    @user = User.new #'@'veriable - instance variable
  end
  def create
    @user = User.new(user_params)
    @user.location_id = 1 # for testing
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Successfully created account"
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
