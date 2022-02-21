class PlantsController < ApplicationController
  before_action :require_user_logged_in!
  before_action :set_plant, only: [:show, :edit, :update, :destroy]

  def index
    @plants = Current.user.plants
    #@plants.build_plant_water_need
  end

  def new
    @plant = Plant.new
    #@water_needs_options = PlantWaterNeed.all
  end

  def create
    @plant = Current.user.plants.new(plant_params)
    @plant.plant_water_need_id = 1

    if @plant.save
      redirect_to plants_path, notice: "Successfully added plant!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @plant.update(plant_params)
      redirect_to plants_path, notice: "Successfully updated plant!"
    else
      render :edit
    end
  end

  def destroy
    @plant.destroy # or delete?
    redirect_to plants_path, notice: "Successfully removed @#{@plant.plant_name} plant"
  end

  private

  def plant_params
    params.require(:plant).permit(:plant_name, :is_indoors, :rooting_depth)
  end

  def set_plant
    @plant = Current.user.plants.find(params[:id])
  end
end
