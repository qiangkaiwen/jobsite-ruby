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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20200309234820) do

  create_table "categories", force: :cascade do |t|
    t.string   "category_name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "chats", force: :cascade do |t|
    t.string   "content"
    t.integer  "user_id"
    t.integer  "hire_id"
    t.integer  "job_id"
    t.integer  "read",       default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "chats", ["hire_id"], name: "index_chats_on_hire_id"
  add_index "chats", ["job_id"], name: "index_chats_on_job_id"
  add_index "chats", ["user_id"], name: "index_chats_on_user_id"

  create_table "hires", force: :cascade do |t|
    t.integer  "job_id"
    t.integer  "user_id"
    t.integer  "state_id",        default: 1
    t.datetime "reg_date",        default: '2020-11-02 22:28:38'
    t.string   "bid_content"
    t.integer  "invitation_read", default: 0
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "hires", ["job_id"], name: "index_hires_on_job_id"
  add_index "hires", ["state_id"], name: "index_hires_on_state_id"
  add_index "hires", ["user_id"], name: "index_hires_on_user_id"

  create_table "jobs", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "reg_date",    default: '2020-11-02 22:28:38'
    t.integer  "state_id",    default: 1
    t.string   "skills"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "jobs", ["category_id"], name: "index_jobs_on_category_id"
  add_index "jobs", ["state_id"], name: "index_jobs_on_state_id"
  add_index "jobs", ["user_id"], name: "index_jobs_on_user_id"

  create_table "rooms", force: :cascade do |t|
    t.string   "title"
    t.string   "image_url"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "rooms", ["user_id"], name: "index_rooms_on_user_id"

  create_table "states", force: :cascade do |t|
    t.string   "state_name"
    t.string   "state_color"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "password"
    t.string   "salt"
    t.string   "image_url"
    t.string   "location"
    t.string   "skill",      default: " "
    t.string   "role",       default: "user"
    t.integer  "used",       default: 0
    t.string   "address",    default: ""
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

end
