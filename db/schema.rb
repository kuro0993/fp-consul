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

ActiveRecord::Schema[7.0].define(version: 2022_06_21_172955) do
  create_table "appoints", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.string "consultation_content"
    t.bigint "customer_id", null: false
    t.bigint "staff_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_appoints_on_customer_id"
    t.index ["staff_id"], name: "index_appoints_on_staff_id"
  end

  create_table "business_time_masters", charset: "utf8mb4", force: :cascade do |t|
    t.integer "weekday_id", limit: 1
    t.string "weekday"
    t.time "start_time"
    t.time "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["weekday_id"], name: "index_business_time_masters_on_weekday_id", unique: true
  end

  create_table "customers", charset: "utf8mb4", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "first_name_kana"
    t.string "last_name_kana"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "staff_appoint_frames", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "acceptable_frame_start"
    t.datetime "acceptable_frame_end"
    t.bigint "staff_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["staff_id"], name: "index_staff_appoint_frames_on_staff_id"
  end

  create_table "staffs", charset: "utf8mb4", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "first_name_kana"
    t.string "last_name_kana"
    t.string "email"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "appoints", "customers"
  add_foreign_key "appoints", "staffs"
  add_foreign_key "staff_appoint_frames", "staffs"
end
