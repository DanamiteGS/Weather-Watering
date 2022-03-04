class PlantWaterNeed < ApplicationRecord
  validates :daily_water_need_factor, numericality: true, uniqueness: true
  validates_presence_of :plant_type, uniqueness: true
end
