class RequestWeatherDataJob
  include Sidekiq::Job

  require "faraday"
  require "json"

  BASE_URL = "https://api.openweathermap.org/data/2.5/"
  WEATHER_API_KEY = ENV['WEATHER_API_KEY']

  def perform(location_id)
    location = Location.find(location_id)

    lat = location.latitude
    lon = location.longitude

    request = ""
    request << BASE_URL << "weather?lat=#{lat}&lon=#{lon}&units=metric&appid=" << WEATHER_API_KEY

    response = Faraday.get(request)

    if response.success?
      weather_json = JSON.parse(response.body)

      tmin = weather_json["main"]["temp_min"]
      tmax = weather_json["main"]["temp_max"]
      tmean = weather_json["main"]["temp"]
      precipitation = weather_json["rain"].present? ? weather_json["rain"]["1h"] : 0

      location.evapotranspiration = location.est_daily_evapotranspiration(tmin, tmax, tmean)
      location.precipitation = precipitation

      location.save
    end
  end
end
