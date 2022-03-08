class Plant < ApplicationRecord
  belongs_to :user
  belongs_to :plant_water_need
  
  accepts_nested_attributes_for :plant_water_need

  validates_associated :plant_water_need

  validates_presence_of :plant_name
  validates_numericality_of :soil_depth, :soil_water_deficit, :maximum_allowable_depletion
  validates :is_indoors, inclusion: { in: [true, false], message: "Please select an option for indoors or outdoors!" }

  before_validation do
    self.soil_water_deficit ||= 0 # Amount of water that left the soil. Program will assume plant has been recently watered and has not lost any water yet
    if self.soil_depth.present?
      self.maximum_allowable_depletion = (available_water * 0.6) # Usually 60% of total water available
    end
  end

  def available_water
    loam_water_holding_capacity = 38.1 # millimeters of water per meter of soil
    return loam_water_holding_capacity * (self.soil_depth / 100)
  end

  def water_deficit(evapotranspiration, precipitation)
    precipitation = 0 if self.is_indoors
    return self.soil_water_deficit + daily_water_need(evapotranspiration) - precipitation
  end

  def daily_water_need(evapotranspiration)
    return self.plant_water_need.daily_water_need_factor * evapotranspiration # returns the amount of water lost
  end
end
