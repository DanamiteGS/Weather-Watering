class PlantsController < ApplicationController

  before_action :require_user_logged_in!
  before_action :set_plant, only: [:edit, :update, :destroy]
  before_action :set_water_needs_options, only: [:new, :edit, :create, :update]
  before_action :ensure_frame_response, only: [:new, :edit]

  def new
    @plant = Plant.new
  end

  def create
    @plant = Current.user.plants.new(plant_params)

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
    respond_to do |format|
      if @plant.destroy
        format.html { redirect_to plants_path, notice: "Successfully deleted plant" }
      end
    end
  end

  private

  def plant_params
    params.require(:plant).permit(:plant_name, :is_indoors, :soil_depth, :plant_water_need_id)
  end

  def set_plant
    @plant = Current.user.plants.find(params[:id])
  end

  def set_water_needs_options
    @water_needs_options ||= PlantWaterNeed.all
  end

  def ensure_frame_response
    redirect_to root_path unless turbo_frame_request?
  end
end
