class CreatePlantWaterNeedFactors < ActiveRecord::Migration[7.0]
  def change
    create_table :plant_water_need_factors do |t|
      t.float :daily_water_need_factor, null: false

      t.timestamps
    end
  end
end
