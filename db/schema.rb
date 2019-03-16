# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_03_15_212519) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "exercise_templates", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exercises", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "routines", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "description", default: "", null: false
    t.string "exercise_groups", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "setts", force: :cascade do |t|
    t.boolean "set_completed", default: false, null: false
    t.integer "set_goal", null: false
    t.integer "reps_completed", null: false
    t.integer "reps_goal", null: false
    t.integer "workout_id", null: false
    t.integer "exercise_id", null: false
    t.integer "weight", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", default: 0, null: false
  end

  create_table "templates", force: :cascade do |t|
    t.integer "routine_id", null: false
    t.integer "exercise_id", null: false
    t.integer "sets", null: false
    t.integer "reps", null: false
    t.string "progression_type", null: false
    t.string "exercise_group", null: false
    t.integer "incremention_scheme", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: ""
    t.string "website", default: ""
    t.string "instagram", default: ""
    t.string "facebook", default: ""
    t.string "twitter", default: ""
    t.string "photo", default: ""
    t.text "about", default: ""
    t.integer "routine_id", default: 0
    t.integer "coach_id", default: 0
    t.boolean "is_coach", default: false, null: false
    t.boolean "is_admin", default: false, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.boolean "approved", default: false, null: false
    t.index ["approved"], name: "index_users_on_approved"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "workouts", force: :cascade do |t|
    t.text "notes", default: ""
    t.integer "user_id", null: false
    t.integer "routine_id", null: false
    t.string "exercise_group", default: "", null: false
    t.boolean "active", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
