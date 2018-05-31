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

ActiveRecord::Schema.define(version: 20180531145828) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alliances", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "needs", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "category"
  end

  create_table "org_alliances", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "alliance_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.boolean  "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_needs", force: :cascade do |t|
    t.integer  "need_id"
    t.integer  "post_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.datetime "time_completed"
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "poster_id"
    t.integer  "claimer_id"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "number_people"
    t.string   "street_1"
    t.string   "street_2"
    t.string   "zip"
    t.string   "city"
    t.string   "state"
    t.datetime "date_posted"
    t.datetime "date_completed"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.text     "comment"
    t.date     "date_claimed"
    t.date     "date_cancelled"
  end

  create_table "sharings", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "alliance_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "password_digest"
    t.string   "role"
    t.integer  "organization_id"
    t.boolean  "active"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "job_title"
  end

end
