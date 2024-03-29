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

ActiveRecord::Schema.define(:version => 20120806200513) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "categories", :force => true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "category_hierarchies", :id => false, :force => true do |t|
    t.integer "ancestor_id",   :null => false
    t.integer "descendant_id", :null => false
    t.integer "generations",   :null => false
  end

  add_index "category_hierarchies", ["ancestor_id", "descendant_id"], :name => "index_category_hierarchies_on_ancestor_id_and_descendant_id", :unique => true
  add_index "category_hierarchies", ["descendant_id"], :name => "index_category_hierarchies_on_descendant_id"

  create_table "comments", :force => true do |t|
    t.integer  "news_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "ip_address"
    t.integer  "reported"
    t.string   "user_agent"
  end

  create_table "event_categories", :force => true do |t|
    t.integer "event_id"
    t.integer "event_type_id"
  end

  create_table "event_ratings", :force => true do |t|
    t.text     "comment"
    t.integer  "user_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "event_id"
    t.string   "ip_address"
    t.float    "overall"
    t.text     "review"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
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
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "user_id"
    t.text     "description"
    t.boolean  "gmaps"
    t.integer  "views"
    t.string   "owner"
    t.float    "cached_rating",      :default => 0.0
    t.string   "state"
    t.string   "city"
    t.string   "zipcode"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "events", ["lat"], :name => "index_events_on_lat"
  add_index "events", ["lng"], :name => "index_events_on_lng"

  create_table "leader_categories", :force => true do |t|
    t.integer "leader_id"
    t.integer "leader_type_id"
  end

  create_table "leader_ratings", :force => true do |t|
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "leader_id"
    t.string   "ip_address"
    t.float    "overall"
    t.text     "review"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "leaders", :force => true do |t|
    t.string   "title"
    t.string   "phone"
    t.text     "address"
    t.string   "website"
    t.float    "lat"
    t.float    "lng"
    t.integer  "picture"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.integer  "user_id"
    t.boolean  "gmaps"
    t.integer  "views"
    t.float    "cached_rating",      :default => 0.0
    t.string   "state"
    t.string   "city"
    t.string   "zipcode"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "city_featured",      :default => false
    t.boolean  "category_featured",  :default => false
  end

  add_index "leaders", ["lat"], :name => "index_leaders_on_lat"
  add_index "leaders", ["lng"], :name => "index_leaders_on_lng"

  create_table "news", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.string   "link"
    t.text     "body"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "views"
    t.string   "photo"
    t.integer  "lock",          :default => 0
    t.integer  "comment_count", :default => 0
    t.boolean  "founders_post", :default => false
  end

  create_table "place_categories", :force => true do |t|
    t.integer "place_id"
    t.integer "place_type_id"
  end

  create_table "place_ratings", :force => true do |t|
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "place_id"
    t.string   "ip_address"
    t.float    "overall"
    t.text     "review"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
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
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.integer  "user_id"
    t.boolean  "gmaps"
    t.integer  "views"
    t.float    "cached_rating",      :default => 0.0
    t.string   "rating_set"
    t.string   "owner"
    t.string   "state"
    t.string   "city"
    t.string   "zipcode"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "city_featured",      :default => false
    t.boolean  "category_featured",  :default => false
  end

  add_index "places", ["lat"], :name => "index_places_on_lat"
  add_index "places", ["lng"], :name => "index_places_on_lng"

  create_table "rankings", :force => true do |t|
    t.integer  "place"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "rankings", ["user_id"], :name => "index_rankings_on_user_id"

  create_table "ratings", :force => true do |t|
    t.string   "text"
    t.string   "for"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "set"
    t.integer  "order"
  end

  create_table "reports", :force => true do |t|
    t.string   "post_type"
    t.integer  "user_id"
    t.integer  "item_id"
    t.string   "report_type"
    t.text     "report_content"
    t.string   "ip_address"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "stars", :force => true do |t|
    t.integer  "user_id"
    t.string   "city"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "awarded"
    t.string   "state"
  end

  add_index "stars", ["user_id"], :name => "index_stars_on_user_id"

  create_table "titles", :force => true do |t|
    t.integer  "user_id"
    t.string   "city"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "place"
    t.string   "state"
  end

  add_index "titles", ["user_id"], :name => "index_titles_on_user_id"

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
    t.integer  "admin"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "display_name"
    t.string   "url"
    t.string   "login"
    t.string   "location"
    t.float    "lat"
    t.float    "lng"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "bio"
    t.string   "facebook_link"
    t.string   "twitter_link"
    t.string   "fb_image"
    t.integer  "stars_count"
    t.integer  "titles_count",                          :default => 0
    t.string   "fb_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
