class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :city, null: false
      t.float :evapotranspiration, null: false
      t.float :precipitation, null: false

      t.timestamps
    end
  end
end
