class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :address, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.float :evapotranspiration
      t.float :precipitation

      t.timestamps
    end
  end
end
