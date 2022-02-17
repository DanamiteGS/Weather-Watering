class LocationWaterContent < ApplicationRecord
  validates_presence_of :city
  validates_numericality_of :evapotranspiration, :precipitation
end
