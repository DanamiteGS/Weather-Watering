class CreatePlantWaterNeeds < ActiveRecord::Migration[7.0]
  def change
    create_table :plant_water_needs do |t|
      t.float :daily_water_need_factor, null: false

      t.timestamps
    end
  end
end
