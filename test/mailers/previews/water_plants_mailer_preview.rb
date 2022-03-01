# Preview all emails at http://localhost:3000/rails/mailers/water_plants_mailer
class WaterPlantsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/water_plants_mailer/water_plant
  def water_plant
    WaterPlantsMailer.water_plant
  end

end
