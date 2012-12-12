# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 18) do

  create_table "calendars", :force => true do |t|
    t.string   "name"
    t.integer  "career_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "careers", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.integer  "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "equipment", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "equipment_events", :force => true do |t|
    t.datetime "dtstart"
    t.datetime "dtend"
    t.integer  "event_id"
    t.integer  "equipment_id"
    t.integer  "space_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.integer  "matter_id"
    t.integer  "space_id"
    t.datetime "dtstart"
    t.datetime "dtend"
    t.text     "exdate"
    t.text     "rdate"
    t.boolean  "recurrent"
    t.string   "freq"
    t.integer  "calendar_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "interval"
    t.datetime "until_date"
    t.string   "byday"
    t.integer  "count"
    t.date     "start_date"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "responsible"
  end

  create_table "matters", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.integer  "career_id"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "responsible"
  end

  create_table "planos", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "space_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spaces", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.text     "description"
    t.integer  "capacity"
    t.integer  "space_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "full_name"
    t.string   "role"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
