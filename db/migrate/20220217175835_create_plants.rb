class CreatePlants < ActiveRecord::Migration[7.0]
  def change
    create_table :plants do |t|
      t.references :user, foreign_key: true
      t.references :plant_water_need, foreign_key: true

      t.string :plant_name, null: false
      t.boolean :is_indoors
      t.float :soil_water_deficit, null: false
      t.float :rooting_depth, null: false
      t.string :minimum_allowable_depletion, null: false

      t.timestamps
    end
  end
end
