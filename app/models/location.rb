class Location < ApplicationRecord
  has_many :users
  has_many :plants, through: :users
  
  validates_presence_of :city
  validates_numericality_of :evapotranspiration, :precipitation, allow_blank: true
end
