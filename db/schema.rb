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

ActiveRecord::Schema[7.1].define(version: 2024_04_13_154407) do
  create_table "clients", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "email"
    t.string "address"
    t.integer "zip_code"
    t.string "country"
    t.integer "age"
    t.string "sex"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "representations", force: :cascade do |t|
    t.integer "representation_external_id"
    t.string "representation_name"
    t.date "representation_date"
    t.time "representation_time"
    t.date "representation_end_date"
    t.time "representation_end_time"
    t.integer "spectacle_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spectacle_id"], name: "index_representations_on_spectacle_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "reservation_external_id"
    t.integer "ticket_number"
    t.date "reservation_date"
    t.time "reservation_time"
    t.string "sales_chanel"
    t.integer "prix"
    t.string "type_of_product"
    t.integer "representation_id", null: false
    t.integer "spectacle_id", null: false
    t.integer "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_reservations_on_client_id"
    t.index ["representation_id"], name: "index_reservations_on_representation_id"
    t.index ["spectacle_id"], name: "index_reservations_on_spectacle_id"
  end

  create_table "spectacles", force: :cascade do |t|
    t.integer "spectacle_external_id"
    t.string "spectacle_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "representations", "spectacles"
  add_foreign_key "reservations", "clients"
  add_foreign_key "reservations", "representations"
  add_foreign_key "reservations", "spectacles"
end
