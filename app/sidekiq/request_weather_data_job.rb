class RequestWeatherDataJob
  include Sidekiq::Job

  sidekiq_options retry: false

  def perform(location_id)
    location = Location.find(location_id)

    weather_data = Weather.new(location.latitude, location.longitude).get_current

    if weather_data.present?

      tmin = weather_data["main"]["temp_min"]
      tmax = weather_data["main"]["temp_max"]
      tmean = weather_data["main"]["temp"]
      precipitation = weather_data["rain"].present? ? weather_data["rain"]["1h"] : 0
      wind_speed = weather_data["wind"]["speed"]

      location.evapotranspiration = Estimate.new(location.latitude, tmin, tmean, tmax, wind_speed).daily_evapotranspiration_penman
      location.precipitation = precipitation

      location.save
    end
  end
end
