class CreateLocationWaterContents < ActiveRecord::Migration[7.0]
  def change
    create_table :location_water_contents do |t|
      t.string :city, null: false
      t.float :evapotranspiration, null: false
      t.float :precipitation, null: false

      t.timestamps
    end
  end
end
