class Weather

  require "faraday"
  require "json"

  BASE_URL = "https://api.openweathermap.org/data/2.5/"
  WEATHER_API_KEY = ENV['WEATHER_API_KEY']

  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
    @request = ""
  end

  def get_current
    @request << BASE_URL << "weather?lat=#{@latitude}&lon=#{@longitude}&units=metric&appid=" << WEATHER_API_KEY

    return make_request(@request)
  end

  def get_weekly_forecast
    @request << BASE_URL << "onecall?lat=#{@latitude}&lon=#{@longitude}&exclude=current,minutely,hourly,alerts&units=metric&appid=" << WEATHER_API_KEY

    return make_request(@request)
  end

  def make_request(request)
    response = Faraday.get(request)

    if response.success?
      return JSON.parse(response.body)
    else
      return nil
    end
  end
end
