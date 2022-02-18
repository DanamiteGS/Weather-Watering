class PlantWaterNeed < ApplicationRecord
  validates :daily_water_need_factor, numericality: true, uniqueness: true
end
