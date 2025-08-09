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

ActiveRecord::Schema[7.1].define(version: 2025_08_09_131911) do
  create_table "sleep_records", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "sleep_time", null: false
    t.datetime "wake_up_time"
    t.integer "duration_seconds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at", "user_id"], name: "idx_sleep_records_time_user"
    t.index ["created_at"], name: "index_sleep_records_on_created_at"
    t.index ["duration_seconds", "user_id", "created_at"], name: "idx_sleep_records_duration_analysis"
    t.index ["duration_seconds"], name: "index_sleep_records_on_duration_seconds"
    t.index ["sleep_time"], name: "index_sleep_records_on_sleep_time"
    t.index ["user_id", "created_at", "duration_seconds"], name: "idx_sleep_records_user_time_duration"
    t.index ["user_id", "created_at"], name: "index_sleep_records_on_user_id_and_created_at"
    t.index ["user_id", "duration_seconds", "created_at"], name: "idx_completed_sleep_records"
    t.index ["user_id", "sleep_time"], name: "idx_active_sleep_records"
    t.index ["user_id"], name: "index_sleep_records_on_user_id"
  end

  create_table "user_followings", force: :cascade do |t|
    t.integer "follower_id", null: false
    t.integer "following_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_id", "created_at"], name: "idx_user_followings_time"
    t.index ["follower_id", "following_id"], name: "idx_user_followings_unique", unique: true
    t.index ["follower_id"], name: "index_user_followings_on_follower_id"
    t.index ["following_id", "follower_id"], name: "idx_user_followings_reverse"
    t.index ["following_id"], name: "index_user_followings_on_following_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_users_on_name"
  end

  add_foreign_key "sleep_records", "users"
  add_foreign_key "user_followings", "users", column: "follower_id"
  add_foreign_key "user_followings", "users", column: "following_id"
end
