class SendReminderToWaterPlantsJob
  include Sidekiq::Job

  def perform(plant_id, user_id)
    plant_name = Plant.where(id: plant_id).pluck(:plant_name)
    owner_email = User.where(id: user_id).pluck(:email)

    if plant_name.present? && owner_email.present?
      WaterPlantsMailer.with(plant_name: plant_name, email: owner_email).water_plant.deliver_now
    end
  end
end
