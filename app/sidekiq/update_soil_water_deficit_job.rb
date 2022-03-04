class UpdateSoilWaterDeficitJob
  include Sidekiq::Job

  sidekiq_options retry: false

  RESET_SOIL_WATER_DEFICIT = 0

  def perform(plant_id, evapotranspiration, precipitation)

    plant = Plant.find(plant_id)
    soil_water_deficit = plant.calculate_soil_water_deficit(evapotranspiration, precipitation)

    if soil_water_deficit > plant.maximum_allowable_depletion
      SendReminderToWaterPlantsJob.perform_async(plant.id, plant.user_id) # Sends an email to the owner of the plant that needs watering
      soil_water_deficit = RESET_SOIL_WATER_DEFICIT
    end

    plant.update(soil_water_deficit: soil_water_deficit)
  end
end
