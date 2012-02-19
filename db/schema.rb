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

ActiveRecord::Schema.define(:version => 20120219212105) do

  create_table "comments", :force => true do |t|
    t.integer  "news_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "event_ratings", :force => true do |t|
    t.integer  "overall"
    t.text     "comment"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "event_id"
  end

  create_table "events", :force => true do |t|
    t.string   "title"
    t.string   "phone"
    t.text     "address"
    t.string   "website"
    t.float    "lat"
    t.float    "lng"
    t.integer  "picture"
    t.date     "start"
    t.date     "end"
    t.string   "timespan"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "leader_ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "voting_record"
    t.integer  "public_views"
    t.integer  "inclusion"
    t.integer  "personal_experience"
    t.integer  "aggregate"
    t.text     "comment"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "leader_id"
  end

  create_table "leaders", :force => true do |t|
    t.string   "title"
    t.string   "phone"
    t.text     "address"
    t.string   "website"
    t.float    "lat"
    t.float    "lng"
    t.integer  "picture"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "news", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.string   "link"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "place_ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "overall"
    t.integer  "same_sex"
    t.integer  "lgbt_group"
    t.integer  "lgbt_comfort"
    t.integer  "customer_attitude"
    t.integer  "lgbt_popularity"
    t.text     "comment"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "place_id"
  end

  create_table "places", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "phone"
    t.text     "address"
    t.string   "website"
    t.float    "lat"
    t.float    "lng"
    t.integer  "picture"
    t.text     "hours_of_operation"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "user_id"
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
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
