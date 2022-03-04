require 'sidekiq-scheduler'

class LocationEnqueuerJob
  include Sidekiq::Job

  def perform
    batch = Sidekiq::Batch.new
    batch.description = "Fetching weather data for all registered locations"
    batch.on(:success, LocationEnqueuerJob::Created, {})
    batch.jobs do
      Location.pluck(:id).each do |location_id|
        RequestWeatherDataJob.perform_async(location_id)
      end
    end
  end

  class Created
    
    def on_success(status, options)
      Location.pluck(:id).each do |location_id|
        PlantEnqueuerJob.perform_async(location_id)
      end
    end
  end
end
