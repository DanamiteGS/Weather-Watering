# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_02_17_175835) do
  create_table "locations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "address", null: false
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.float "evapotranspiration"
    t.float "precipitation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plant_water_needs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "daily_water_need_factor", null: false
    t.string "plant_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plants", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "plant_water_need_id"
    t.string "plant_name", null: false
    t.boolean "is_indoors"
    t.float "soil_water_deficit", null: false
    t.float "rooting_depth", null: false
    t.float "maximum_allowable_depletion", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plant_water_need_id"], name: "index_plants_on_plant_water_need_id"
    t.index ["user_id"], name: "index_plants_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "location_id"
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_users_on_location_id"
  end

  add_foreign_key "plants", "plant_water_needs"
  add_foreign_key "plants", "users"
  add_foreign_key "users", "locations"
end
