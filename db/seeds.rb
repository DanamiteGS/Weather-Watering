# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

PlantWaterNeed.create([ # Set default values for each plant's water need group
  { daily_water_need_factor: "1", plant_type: "Water loving" },
  { daily_water_need_factor: "0.6", plant_type: "Drought Tolerant" },
  { daily_water_need_factor: "0.3", plant_type: "Succulent" }
])