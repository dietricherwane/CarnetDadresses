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

ActiveRecord::Schema.define(version: 20140930160235) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adress_books", force: true do |t|
    t.string   "firstname",          limit: 100
    t.string   "lastname",           limit: 100
    t.string   "company_name",       limit: 100
    t.string   "email",              limit: 100
    t.string   "phone_number",       limit: 100
    t.string   "mobile_number",      limit: 100
    t.integer  "profile_id"
    t.integer  "social_status_id"
    t.string   "trading_identifier", limit: 100
    t.integer  "created_by"
    t.boolean  "published"
    t.integer  "sector_id"
    t.integer  "sales_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment"
  end

  create_table "forum_posts", force: true do |t|
    t.text     "comment"
    t.integer  "created_by"
    t.boolean  "unpublished"
    t.datetime "unpublished_at"
    t.integer  "unpublished_by"
    t.integer  "forum_theme_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forum_themes", force: true do |t|
    t.string   "title"
    t.integer  "sector_id"
    t.integer  "sales_area_id"
    t.boolean  "published"
    t.integer  "validated_by"
    t.datetime "validated_at"
    t.integer  "unpublished_by"
    t.datetime "unpublished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "helps", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "website_content"
    t.integer  "website_user_id"
    t.datetime "website_updated_at"
    t.text     "wallet_content"
    t.integer  "wallet_user_id"
    t.datetime "wallet_updated_at"
  end

  create_table "information", force: true do |t|
    t.text     "content"
    t.boolean  "published"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "last_updates", force: true do |t|
    t.integer  "user_id"
    t.integer  "update_type_id"
    t.string   "firstname",              limit: 100
    t.string   "lastname",               limit: 100
    t.string   "company_name",           limit: 100
    t.string   "email",                  limit: 100
    t.string   "phone_number",           limit: 100
    t.string   "mobile_number",          limit: 100
    t.integer  "profile_id"
    t.integer  "social_status_id"
    t.string   "trading_identifier",     limit: 100
    t.integer  "created_by"
    t.boolean  "published"
    t.integer  "sector_id"
    t.integer  "sales_area_id"
    t.string   "new_firstname",          limit: 100
    t.string   "new_lastname",           limit: 100
    t.string   "new_company_name",       limit: 100
    t.string   "new_email",              limit: 100
    t.string   "new_phone_number",       limit: 100
    t.string   "new_mobile_number",      limit: 100
    t.integer  "new_profile_id"
    t.integer  "new_social_status_id"
    t.string   "new_trading_identifier", limit: 100
    t.integer  "new_created_by"
    t.boolean  "new_published"
    t.integer  "new_sector_id"
    t.integer  "new_sales_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment"
    t.text     "new_comment"
  end

  create_table "news_feeds", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "publication_date"
    t.boolean  "published"
    t.integer  "user_id"
    t.string   "picture"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", force: true do |t|
    t.string   "name",       limit: 50
    t.string   "shortcut",   limit: 5
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales_areas", force: true do |t|
    t.string   "name",       limit: 100
    t.boolean  "published"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sectors", force: true do |t|
    t.string   "name",       limit: 100
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "social_statuses", force: true do |t|
    t.string   "name",       limit: 100
    t.boolean  "published"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "update_types", force: true do |t|
    t.string   "name",       limit: 50
    t.integer  "created_by"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",                 default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                    default: 10
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "phone_number"
    t.string   "mobile_number"
    t.integer  "profile_id"
    t.boolean  "published"
    t.integer  "social_status_id"
    t.string   "trading_identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company_name",           limit: 100
    t.integer  "created_by"
    t.integer  "sector_id"
    t.integer  "sales_area_id"
    t.string   "shortcut",               limit: 15
    t.text     "comment"
    t.string   "logo"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
