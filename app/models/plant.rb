class Plant < ApplicationRecord
  belongs_to :user
  belongs_to :plant_water_need

  validates_presence_of :plant_name
  validates_numericality_of :rooting_depth, :soil_water_deficit, :minimum_allowable_depletion

  # validate :plant_name Must be unique among a users plants list
end
