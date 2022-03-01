class RequestWeatherDataJob
  include Sidekiq::Job

  def perform(location_id)
    location = Location.find(location_id)

    location.evapotranspiration = location.est_daily_evapotranspiration(24, 29) # Temporary
    location.precipitation = 0.4

    # Add specific location latitude and logitude to URL + API KEY

    # https://flexiple.com/rails-parse-json/

    # response = conn.get(url)
    
    # if response.success?
      # parsed_response = JSON.pase(response)

      # location.evapotranspiration = location.est_daily_evapotranspiration(tmin, tmax)
      # location.precipitation = # precipitation form API call
      
      location.save
    # end
  end
end
