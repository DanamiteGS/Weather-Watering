class WebDemoForm
  include ActiveModel::Model

  attr_accessor :location, :plant

  delegate :attributes=, :to => :plant, :prefix => true, :allow_nil => false
  delegate :attributes=, :to => :location, :prefix => true, :allow_nil => false

  def initialize(params= {})
    @location = Location.new
    @plant = Plant.new
    super(params)
  end

  def submit
    get_weather_data

    plant.is_indoors = false # Calculations do not take into account precipitation
    plant.maximum_allowable_depletion = (plant.available_water * 0.6)
    daily_water_deficit = plant.daily_water_need(location.evapotranspiration)

    days_until_next_watering = plant.maximum_allowable_depletion / daily_water_deficit

    return days_until_next_watering.round
  end

  def get_weather_data
    weather_data = Weather.new(location.latitude, location.longitude).get_current

    if weather_data.present?

      puts weather_data

      tmin = weather_data["main"]["temp_min"]
      tmax = weather_data["main"]["temp_max"]
      tmean = weather_data["main"]["temp"]
      wind_speed = weather_data["wind"]["speed"]

      location.evapotranspiration = Estimate.new(location.latitude, tmin, tmean, tmax, wind_speed).daily_evapotranspiration_penman
      puts "evapotranspiration"
      puts location.evapotranspiration
    end
  end
end