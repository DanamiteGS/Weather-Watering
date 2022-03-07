class Weather

  require "faraday"
  require "json"

  BASE_URL = "https://api.openweathermap.org/data/2.5/"
  WEATHER_API_KEY = ENV['WEATHER_API_KEY']

  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
  end

  def get_forecast
    request = ""
    request << BASE_URL << "weather?lat=#{@latitude}&lon=#{@longitude}&units=metric&appid=" << WEATHER_API_KEY

    response = Faraday.get(request)

    if response.success?
      return JSON.parse(response.body)
    else
      return nil
    end
  end
end
