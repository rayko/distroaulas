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

ActiveRecord::Schema.define(:version => 7) do

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
  end

  create_table "matters", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.integer  "career_id"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", :force => true do |t|
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

end
