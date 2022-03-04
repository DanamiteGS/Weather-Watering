class UsersController < ApplicationController
  
  before_action :require_user_logged_out, only: [:new, :create]
  before_action :require_user_logged_in!, only: [:show, :edit, :update, :destroy]

  def new
    @user = User.new
    @user.build_location
  end

  def create
    @user = User.new(user_params)
    @user.location = Location.where(address: @user.location.address).first_or_create(:latitude => @user.location.latitude, :longitude => @user.location.longitude)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Successfully created account"
    else
      render :new
    end
  end

  # TODO: Alow user to edit their profile

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, location_attributes: [:address, :latitude, :longitude])
  end
end
