class UsersController < ApplicationController
  
  before_action :require_user_logged_out, only: [:new, :create]
  before_action :require_user_logged_in!, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:edit_address, :update_address, :edit_email, :update_email, :destroy]

  def show
    @user = User.find_by(id: session[:user_id])
    
    @plants = @user.plants

    @plants.each do |plant|
      plant.plant_water_need = plant.plant_water_need # How could this be better?
    end
  end

  def new
    @user = User.new
    @user.build_location
  end

  def create
    @user = User.new(user_params)
    @user.location = Location.where(address: @user.location.address).first_or_create(:latitude => @user.location.latitude, :longitude => @user.location.longitude)

    if @user.save
      session[:user_id] = @user.id
      flash[:primary] = "Welcome new weather waterer!"
      redirect_to me_path
    else
      render :new
    end
  end

  def edit_address
  end

  def edit_email
  end

  def update_address
    location_attributes = address_params.dig(:location_attributes)
    location = Location.where(address: location_attributes.dig(:address)).first_or_create(:latitude => location_attributes.dig(:latitude), :longitude => location_attributes.dig(:longitude))
    
    respond_to do |format|
      if @user.update(location: location)
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@user, partial: "users/user", locals: { user: @user })
        end
        format.html { redirect_to me_path }
      else
        format.html { render :edit_address, status: :unprocessable_entity }
      end
    end
  end

  def update_email
    respond_to do |format|
      if @user.update(email_params)
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@user, partial: "users/user", locals: { user: @user })
        end
        format.html { redirect_to me_path }
      else
        format.html { render :edit_email, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    session[:user_id] = nil
    location = @user.location
    @user.destroy

    if location.users.empty?
      location.destroy
    end
    
    flash[:primary] = "Successfully deleted account"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, location_attributes: [:address, :latitude, :longitude])
  end

  def email_params
    params.require(:user).permit(:email)
  end

  def address_params
    params.require(:user).permit(location_attributes: [:address, :latitude, :longitude])
  end

  def set_user
    @user = User.find_by(id: session[:user_id])
  end

end
