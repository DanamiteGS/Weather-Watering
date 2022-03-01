class Location < ApplicationRecord
  has_many :users
  has_many :plants, through: :users
  
  validates_presence_of :address
  validates_numericality_of :latitude, :longitude
  validates_numericality_of :evapotranspiration, :precipitation, allow_blank: true

  require 'evapotranspiration/fao'
  require 'evapotranspiration/conversion'
  require 'time'

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

  def est_daily_evapotranspiration(tmin, tmax)
    tmean = Evapotranspiration::FAO.daily_mean_t(tmin, tmax)
    et_rad = est_daily_et_rad

    return Evapotranspiration::FAO.hargreaves(tmin, tmax, tmean, et_rad)
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

  def est_daily_et_rad
    day_of_year = Time.now.yday
    latitude_radians = Evapotranspiration::Conversion.deg_to_rad(self.latitude)

    sol_dec = Evapotranspiration::FAO.sol_dec(day_of_year)
    sha = Evapotranspiration::FAO.sunset_hour_angle(latitude_radians, sol_dec)
    ird = Evapotranspiration::FAO.inv_rel_dist_earth_sun(day_of_year)

    return Evapotranspiration::FAO.et_rad(latitude_radians, sol_dec, sha, ird)
  end
end
