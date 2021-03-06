class CreatePlants < ActiveRecord::Migration[7.0]
  def change
    create_table :plants do |t|
      t.references :user, foreign_key: true
      t.references :plant_water_need, foreign_key: true

      t.string :plant_name, null: false
      t.boolean :is_indoors
      t.float :soil_water_deficit, null: false
      t.float :soil_depth, null: false
      t.float :maximum_allowable_depletion, null: false

      t.timestamps
    end
  end
end
