class Plant < ApplicationRecord
  belongs_to :user
  belongs_to :plant_water_need
  
  accepts_nested_attributes_for :plant_water_need

  validates_associated :plant_water_need

  validates_presence_of :plant_name
  validates_numericality_of :rooting_depth, :soil_water_deficit, :maximum_allowable_depletion

  before_save do
    self.soil_water_deficit ||= 0 # Amount of water that left the soil. Program will assume plant has been recently watered and has not lost any water yet
    if self.rooting_depth.present?
      self.maximum_allowable_depletion = (total_water_available / 2) # Usually 50% of total water available
    end
  end

  def total_water_available
    loams_available_water_holding_capacity = 1.5 # Amount of water that loam soil can retain
    return (loams_available_water_holding_capacity * self.rooting_depth)
  end

  def calculate_soil_water_deficit(et, precipitation)
    daily_water_need_factor = self.plant_water_need.daily_water_need_factor
    precipitation = 0 if self.is_indoors

    return self.soil_water_deficit + et + daily_water_need_factor - precipitation
  end
end
