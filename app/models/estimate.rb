class Estimate

  require 'evapotranspiration/fao'
  require 'evapotranspiration/conversion'
  require 'evapotranspiration/validation'
  require 'time'

  def initialize(latitude, tmin, tmean, tmax, wind_speed=0)
    @latitude = latitude
    @tmin = tmin
    @tmax = tmax
    @tmean = tmean
    @wind_speed = wind_speed
  end

  # Estimate reference evapotranspiration over grass (ETo) using the Hargreaves equation.
  #
  # Based on equation 52 in Allen et al (1998).
  #
  # @param tmin [Float] Minimum daily temperature (deg C)
  # @param tmax [Float] Maximum daily temperature (deg C)
  # @param tmean [Float] Mean daily temperature (deg C). If measurements not
  #   available it can be estimated as (*tmin* + *tmax*) / 2
  # @param et_rad [Float] Extraterrestrial radiation (Ra) (MJ m-2 day-1).
  #   Can be estimated using et_rad
  # @return [Float] Reference evapotranspiration over grass (ETo) (mm day-1)

  def daily_evapotranspiration_hargreaves
    return Evapotranspiration::FAO.hargreaves(@tmin, @tmax, @tmean, daily_et_rad)
  end

  # Estimate daily extraterrestrial radiation (*Ra*, 'top of the atmosphere radiation').
  #
  # Based on equation 21 in Allen et al (1998).
  #
  # @param latitude [Float] Latitude (radians)
  # @param sol_dec [Float] Solar declination (radians). Can be calculated
  #   using sol_dec
  # @param sha [Float] Sunset hour angle (radians). Can be calculated using
  #   sunset_hour_angle
  # @param ird [Float] Inverse relative distance earth-sun (dimensionless).
  #   Can be calculated using inv_rel_dist_earth_sun
  # @return [Float] Daily extraterrestrial radiation (MJ m-2 day-1)

  def daily_et_rad
    ird = Evapotranspiration::FAO.inv_rel_dist_earth_sun(day_of_year)

    return Evapotranspiration::FAO.et_rad(latitude_radians, sol_dec, sunset_hour_angle, ird)
  end
  
    # Estimate reference evapotranspiration (ETo) from a hypothetical
    # short grass reference surface using the FAO-56 Penman-Monteith equation.
    #
    # Based on equation 6 in Allen et al (1998).
    #
    # @param net_rad [Float] Net radiation at crop surface (MJ m-2 day-1). If
    #   necessary this can be estimated using net_rad


    # @param t [Float] Air temperature at 2 m height (deg Kelvin)
    # @param ws [Float] Wind speed at 2 m height (m s-1). If not measured at 2m,
    #   convert using wind_speed_at_2m
    # @param svp [Float] Saturation vapour pressure (kPa). Can be estimated
    #   using svp_from_t
    # @param avp [Float] Actual vapour pressure (kPa). Can be estimated using a
    #   range of methods with names beginning with avp_from
    # @param delta_svp [Float] Slope of saturation vapour pressure curve
    #   (kPa degC-1). Can be estimated using delta_svp
    # @param psy [Float] Psychrometric constant (kPa deg C). Can be estimatred
    #   using psy_const_of_psychrometer or psy_const
    # @param shf [Float] Soil heat flux (G) (MJ m-2 day-1) (default is 0.0,
    #   which is reasonable for a daily or 10-day time steps). For monthly time
    #   steps *shf* can be estimated using monthly_soil_heat_flux or
    #   monthly_soil_heat_flux2
    # @return [Float] Reference evapotranspiration (ETo) from a hypothetical
    #   grass reference surface (mm day-1)

  def daily_evapotranspiration_penman
    net_rad = net_radiation
    t = @tmean
    ws = wind_speed_2m
    svp = saturation_vapour_pressure
    avp = actual_vapour_pressure
    delta_svp = delta_saturation_vapour_pressure
    psy = psychometric_constant

    evapotranspiration = Evapotranspiration::FAO.fao56_penman_monteith(net_rad, t, ws, svp, avp, delta_svp, psy, shf=0.0) * 0.11
    evapotranspiration = 0.4 if evapotranspiration <= 0.3
    
    return evapotranspiration
  end
  
  # Calculate the psychrometric constant for different types of psychrometer at a given atmospheric pressure.

  def psychometric_constant
    return Evapotranspiration::FAO.psy_const(atmos_pressure)
  end

  # Estimate atmospheric pressure(kPa) from altitude above sea level (m).

  def atmos_pressure
    altitude = 841 # Average height of the exposed surface is 841 m

    return Evapotranspiration::FAO.atm_pressure(altitude)
  end

  # Estimate the slope of the saturation vapour pressure curve at a given temperature.

  def delta_saturation_vapour_pressure
    return Evapotranspiration::FAO.delta_svp(@tmean)
  end

  # Estimate actual vapour pressure (*ea*) from minimum temperature.

  def actual_vapour_pressure
    return Evapotranspiration::FAO.avp_from_tmin(@tmin)
  end

  # Estimate saturation vapour pressure (*es*) from air temperature.

  def saturation_vapour_pressure
    return Evapotranspiration::FAO.svp_from_t(@tmean)
  end

  # Convert wind speed measured at different heights above the soil surface to wind speed at 2 m above the surface

  def wind_speed_2m
    altitude = 10 # It is normally assumed that the wind speed measurement was taken at 10 m.
    return  Evapotranspiration::FAO.wind_speed_2m(@wind_speed, altitude)
  end

  # Calculate daily net radiation at the crop surface

  def net_radiation
    return Evapotranspiration::FAO.net_rad(net_incoming_sol_rad, net_outgoing_longwave_rad)
  end

  # Calculate net incoming solar (or shortwave) radiation from gross incoming solar radiation

  def net_incoming_sol_rad
    return Evapotranspiration::FAO.net_in_sol_rad(sol_rad_from_sun_hours, albedo=0.23)
  end

  # Calculate incoming solar (or shortwave) radiation, *Rs* (radiation hitting a horizontal 
  # plane after scattering by the atmosphere) from relative sunshine duration.

  def sol_rad_from_sun_hours
    return Evapotranspiration::FAO.sol_rad_from_sun_hours(daylight_hours, sunshine_hours, daily_et_rad)
  end

  def sunshine_hours
    return 4.352 + (0.232 * @tmean)
  end

  # Calculate daylight hours from sunset hour angle.

  def daylight_hours
    return Evapotranspiration::FAO.daylight_hours(sunset_hour_angle)
  end

  # Calculate sunset hour angle (*Ws*) from latitude and solar declination.

  def sunset_hour_angle
    return Evapotranspiration::FAO.sunset_hour_angle(latitude_radians, sol_dec)
  end

  # Estimate net outgoing longwave radiation.

  def net_outgoing_longwave_rad
    return Evapotranspiration::FAO.net_out_lw_rad(@tmin, @tmax, sol_rad_from_sun_hours, clear_sky_rad, actual_vapour_pressure)
  end

  # Estimate clear sky radiation from altitude and extraterrestrial radiation.

  def clear_sky_rad
    altitude = 841 # Average height of the exposed surface is 841 m
    return Evapotranspiration::FAO.cs_rad(altitude, daily_et_rad)
  end

  # Return day the day of the year

  def day_of_year
    return Time.now.yday
  end

  # Convert angular degrees to radians

  def latitude_radians
    return Evapotranspiration::Conversion.deg_to_rad(@latitude)
  end

  # Calculate solar declination from day of the year.

  def sol_dec
    return Evapotranspiration::FAO.sol_dec(day_of_year)
  end
end
