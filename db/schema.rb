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

ActiveRecord::Schema[8.1].define(version: 2026_08_10_210000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "cut_recommendations", force: :cascade do |t|
    t.datetime "approved_at"
    t.bigint "approved_by_manager_id"
    t.datetime "created_at", null: false
    t.string "reason", null: false
    t.bigint "server_shift_id", null: false
    t.bigint "shift_id", null: false
    t.string "status", default: "open", null: false
    t.datetime "updated_at", null: false
    t.index ["approved_by_manager_id"], name: "index_cut_recommendations_on_approved_by_manager_id"
    t.index ["server_shift_id"], name: "index_cut_recommendations_on_server_shift_id"
    t.index ["shift_id"], name: "index_cut_recommendations_on_shift_id"
  end

  create_table "decision_events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "detail", default: "", null: false
    t.string "kind", null: false
    t.bigint "party_id"
    t.bigint "shift_id", null: false
    t.string "summary", null: false
    t.datetime "updated_at", null: false
    t.index ["party_id"], name: "index_decision_events_on_party_id"
    t.index ["shift_id", "created_at"], name: "index_decision_events_on_shift_id_and_created_at"
    t.index ["shift_id"], name: "index_decision_events_on_shift_id"
  end

  create_table "dining_tables", force: :cascade do |t|
    t.integer "capacity", null: false
    t.boolean "combinable", default: false, null: false
    t.datetime "created_at", null: false
    t.string "label", null: false
    t.datetime "seated_at"
    t.bigint "section_id", null: false
    t.string "status", default: "open", null: false
    t.datetime "updated_at", null: false
    t.index ["label"], name: "index_dining_tables_on_label"
    t.index ["section_id"], name: "index_dining_tables_on_section_id"
  end

  create_table "managers", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "pin", null: false
    t.datetime "updated_at", null: false
    t.index ["pin"], name: "index_managers_on_pin", unique: true
  end

  create_table "pacing_recommendations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "decided_at"
    t.integer "hold_minutes", default: 10, null: false
    t.string "message", null: false
    t.bigint "shift_id", null: false
    t.string "status", default: "open", null: false
    t.datetime "updated_at", null: false
    t.index ["shift_id"], name: "index_pacing_recommendations_on_shift_id"
  end

  create_table "parties", force: :cascade do |t|
    t.string "confirmation_status", default: "pending", null: false
    t.integer "covers", null: false
    t.datetime "created_at", null: false
    t.bigint "dining_table_id"
    t.string "lifecycle", default: "booked", null: false
    t.string "name", null: false
    t.string "note", default: ""
    t.integer "queue_position"
    t.integer "quoted_wait_minutes"
    t.time "reservation_time"
    t.boolean "rush_tagged", default: false, null: false
    t.bigint "server_shift_id"
    t.bigint "shift_id", null: false
    t.string "source", default: "reservation", null: false
    t.string "tags", default: [], null: false, array: true
    t.datetime "updated_at", null: false
    t.index ["dining_table_id"], name: "index_parties_on_dining_table_id"
    t.index ["server_shift_id"], name: "index_parties_on_server_shift_id"
    t.index ["shift_id", "confirmation_status"], name: "index_parties_on_shift_id_and_confirmation_status"
    t.index ["shift_id", "lifecycle"], name: "index_parties_on_shift_id_and_lifecycle"
    t.index ["shift_id"], name: "index_parties_on_shift_id"
  end

  create_table "seating_recommendations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "dining_table_id", null: false
    t.string "override_reason"
    t.bigint "party_id", null: false
    t.bigint "server_shift_id", null: false
    t.string "status", default: "open", null: false
    t.string "summary", null: false
    t.datetime "updated_at", null: false
    t.index ["dining_table_id"], name: "index_seating_recommendations_on_dining_table_id"
    t.index ["party_id"], name: "index_seating_recommendations_on_party_id"
    t.index ["server_shift_id"], name: "index_seating_recommendations_on_server_shift_id"
  end

  create_table "sections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "pickup_server_shift_id"
    t.integer "position", default: 0, null: false
    t.bigint "server_shift_id"
    t.bigint "shift_id", null: false
    t.datetime "updated_at", null: false
    t.index ["pickup_server_shift_id"], name: "index_sections_on_pickup_server_shift_id"
    t.index ["server_shift_id"], name: "index_sections_on_server_shift_id"
    t.index ["shift_id", "name"], name: "index_sections_on_shift_id_and_name", unique: true
    t.index ["shift_id"], name: "index_sections_on_shift_id"
  end

  create_table "server_shifts", force: :cascade do |t|
    t.datetime "clocked_in_at"
    t.decimal "covers_per_hour", precision: 5, scale: 1, default: "0.0", null: false
    t.integer "covers_tonight", default: 0, null: false
    t.datetime "created_at", null: false
    t.string "cut_status", default: "none", null: false
    t.bigint "server_id", null: false
    t.bigint "shift_id", null: false
    t.integer "start_order", null: false
    t.datetime "updated_at", null: false
    t.index ["server_id"], name: "index_server_shifts_on_server_id"
    t.index ["shift_id", "server_id"], name: "index_server_shifts_on_shift_id_and_server_id", unique: true
    t.index ["shift_id", "start_order"], name: "index_server_shifts_on_shift_id_and_start_order"
    t.index ["shift_id"], name: "index_server_shifts_on_shift_id"
  end

  create_table "servers", force: :cascade do |t|
    t.decimal "baseline_covers_per_hour", precision: 5, scale: 1, default: "10.0", null: false
    t.string "capability", default: "standard", null: false
    t.datetime "created_at", null: false
    t.string "initial", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shifts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "location_name", default: "The Hearth Room", null: false
    t.datetime "pacing_hold_until"
    t.boolean "rush_mode", default: false, null: false
    t.boolean "sections_approved", default: false, null: false
    t.datetime "sections_approved_at"
    t.date "service_date", null: false
    t.datetime "updated_at", null: false
    t.integer "walk_in_forecast", default: 0, null: false
    t.string "walk_in_forecast_detail", default: "", null: false
    t.index ["service_date"], name: "index_shifts_on_service_date"
  end

  add_foreign_key "cut_recommendations", "managers", column: "approved_by_manager_id"
  add_foreign_key "cut_recommendations", "server_shifts"
  add_foreign_key "cut_recommendations", "shifts"
  add_foreign_key "decision_events", "parties"
  add_foreign_key "decision_events", "shifts"
  add_foreign_key "dining_tables", "sections"
  add_foreign_key "pacing_recommendations", "shifts"
  add_foreign_key "parties", "dining_tables"
  add_foreign_key "parties", "server_shifts"
  add_foreign_key "parties", "shifts"
  add_foreign_key "seating_recommendations", "dining_tables"
  add_foreign_key "seating_recommendations", "parties"
  add_foreign_key "seating_recommendations", "server_shifts"
  add_foreign_key "sections", "server_shifts"
  add_foreign_key "sections", "server_shifts", column: "pickup_server_shift_id"
  add_foreign_key "sections", "shifts"
  add_foreign_key "server_shifts", "servers"
  add_foreign_key "server_shifts", "shifts"
end
