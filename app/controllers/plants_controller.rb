class PlantsController < ApplicationController

  before_action :require_user_logged_in!
  before_action :set_plant, only: [:show, :edit, :update, :destroy]
  #before_action :water_needs_options, only: [:new, :edit]
  before_action :ensure_frame_response, only: [:new, :edit]

  def index
    @plants = Current.user.plants

    @plants.each do |plant|
      plant.plant_water_need = plant.plant_water_need # How could this be better?
    end
  end

  def new
    @plant = Plant.new
  end

  def create
    @plant = Current.user.plants.new(plant_params)
    @plant.plant_water_need_id = 1 # Temporary
 
    respond_to do |format|
      if @plant.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.prepend('plants', partial: 'plants/plant', locals: { plant: @plant })
        end
        format.html { redirect_to plant_url(@plant), notice: "Plant was successfully added." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @plant.update(plant_params)
        format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@plant, partial: "plants/plant", locals: { plant: @plant })
        end
        format.html { redirect_to plant_url(@plant), notice: "Plant was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @plant.destroy # or delete?
    redirect_to plants_path, notice: "Successfully removed @#{@plant.plant_name} plant"
  end

  private

  def plant_params
    params.require(:plant).permit(:plant_name, :is_indoors, :rooting_depth, plant_water_need_attributes: [:id])
  end

  def set_plant
    @plant = Current.user.plants.find(params[:id])
  end

  def set_water_needs_options
    @water_needs_options = PlantWaterNeed.pluck_all(:id, :daily_water_need_factor)
  end

  def ensure_frame_response
    redirect_to root_path unless turbo_frame_request?
  end
end
