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

ActiveRecord::Schema.define(version: 20160711073334) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "cuisines", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "avatar"
  end

  create_table "foods", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price"
    t.text     "description"
    t.integer  "cuisine_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "restaurant_id"
  end

  add_index "foods", ["cuisine_id"], name: "index_foods_on_cuisine_id"
  add_index "foods", ["restaurant_id"], name: "index_foods_on_restaurant_id"

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "rating_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "likes", ["post_id"], name: "index_likes_on_post_id"
  add_index "likes", ["rating_id"], name: "index_likes_on_rating_id"
  add_index "likes", ["user_id"], name: "index_likes_on_user_id"

  create_table "locations", force: :cascade do |t|
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "restaurant_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "locations", ["restaurant_id"], name: "index_locations_on_restaurant_id"

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "message"
    t.boolean  "status",     default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id"

  create_table "pictures", force: :cascade do |t|
    t.integer  "restaurant_id"
    t.boolean  "status",        default: false
    t.integer  "user_id"
    t.string   "pic"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "pictures", ["restaurant_id"], name: "index_pictures_on_restaurant_id"
  add_index "pictures", ["user_id"], name: "index_pictures_on_user_id"

  create_table "posts", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "restaurant_id"
    t.text     "comment"
  end

  add_index "posts", ["restaurant_id"], name: "index_posts_on_restaurant_id"

  create_table "ratings", force: :cascade do |t|
    t.integer  "rate"
    t.text     "comment"
    t.integer  "restaurant_id"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "ratings", ["restaurant_id"], name: "index_ratings_on_restaurant_id"
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id"

  create_table "replies", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "rating_id"
    t.integer  "post_id"
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "replies", ["post_id"], name: "index_replies_on_post_id"
  add_index "replies", ["rating_id"], name: "index_replies_on_rating_id"
  add_index "replies", ["user_id"], name: "index_replies_on_user_id"

  create_table "restaurants", force: :cascade do |t|
    t.string   "name"
    t.text     "address"
    t.string   "contact"
    t.string   "status",     default: "Pending"
    t.text     "map"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "avatar"
    t.string   "cover"
    t.integer  "user_id"
    t.string   "website"
  end

  add_index "restaurants", ["user_id"], name: "index_restaurants_on_user_id"

  create_table "schedules", force: :cascade do |t|
    t.string   "day"
    t.string   "opening"
    t.string   "closing"
    t.integer  "restaurant_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "schedules", ["restaurant_id"], name: "index_schedules_on_restaurant_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "username"
    t.string   "name"
    t.boolean  "admin",                  default: false
    t.string   "profile_picture_url"
    t.text     "location"
    t.string   "avatar"
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
