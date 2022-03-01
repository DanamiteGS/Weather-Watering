class PlantEnqueuerJob
  include Sidekiq::Job

  require 'pluck_all'

  sidekiq_options retry: false

  def perform(location_id)
    weather_data = Location.where(id: location_id).pluck_all(:evapotranspiration, :precipitation)

    evapotranspiration = weather_data[0]['evapotranspiration']
    precipitation = weather_data[0]['precipitation']

    plant_ids = Plant.joins(:user => :location).where(:location => {id: location_id}).pluck(:id)

    plant_ids.each do |plant_id|
      UpdateSoilWaterDeficitJob.perform_async(plant_id, evapotranspiration, precipitation)
    end
  end
end
