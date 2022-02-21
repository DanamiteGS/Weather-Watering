class UsersController < ApplicationController
  before_action :require_user_logged_in!, only: [:show, :edit, :update, :destroy]
  
  def new
    @user = User.new #'@'veriable - instance variable
    @user.build_location # @user.location.new
  end

  def create
    @user = User.new(user_params)
    @user.location = Location.where(city: @user.location.city).first_or_create

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Successfully created account"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to plants_path, notice: "Successfully updated user!"
    else
      render :edit
    end
  end

  #def destroy
  #  @user.destroy # or delete?
  #  redirect_to plants_path, notice: "Successfully removed @#{@plant.plant_name} plant"
  #end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, location_attributes: [:city])
  end
end
