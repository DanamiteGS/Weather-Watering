class WaterPlantsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.water_plants_mailer.water_plant.subject
  #

  def water_plant
    @plant_name = params[:plant_name]
    @email = params[:email]

    mail(
      to: @email, 
      subject: "Time to water #{@plant_name}!"
    )
  end
end
