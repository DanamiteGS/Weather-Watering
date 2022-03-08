class WelcomeController < ApplicationController

  before_action :set_water_needs_options, only: [:index, :create]
  
  def index
    @web_demo = WebDemoForm.new
  end

  def create
    @web_demo = WebDemoForm.new(web_demo_form_params)

    if params_are_present
      days_until_next_watering = @web_demo.submit
      
      @web_demo = WebDemoForm.new
      @web_demo.errors.add(:base, "Water in #{days_until_next_watering} days!🌳")
      render :index
    else
      @web_demo.errors.add(:base, "Please complete all fields!")
      render :index
    end
  end

  private

  def web_demo_form_params
    params.require(:web_demo_form).permit(location_attributes: [:address, :latitude, :longitude], 
                                          plant_attributes: [:is_indoors, :soil_depth, :plant_water_need_id])
  end

  def set_water_needs_options
    @water_needs_options ||= PlantWaterNeed.all
  end
  
  def params_are_present
    web_demo_form_params.each do |key, value|
      value.each do |k, v|
        if !value.dig(k).present?
          return false
        end
      end
    end
    return true
  end
end
