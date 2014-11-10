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

ActiveRecord::Schema.define(version: 20141110111026) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "address_book_title_categories", force: true do |t|
    t.string   "name"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "address_book_titles", force: true do |t|
    t.string   "name"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "address_book_title_category_id"
  end

  create_table "adress_book_hobbies", force: true do |t|
    t.integer  "adress_book_id"
    t.integer  "hobby_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "published"
  end

  create_table "adress_books", force: true do |t|
    t.string   "firstname",             limit: 100
    t.string   "lastname",              limit: 100
    t.string   "company_name",          limit: 100
    t.string   "email",                 limit: 100
    t.string   "phone_number",          limit: 100
    t.integer  "profile_id"
    t.integer  "created_by"
    t.boolean  "published"
    t.integer  "sector_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment"
    t.integer  "civility_id"
    t.date     "birthdate"
    t.integer  "marital_status_id"
    t.integer  "childrens"
    t.string   "job_role"
    t.string   "geographical_address"
    t.string   "postal_address"
    t.string   "city"
    t.integer  "country_id"
    t.integer  "address_book_title_id"
    t.string   "employment_company"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "company_id"
    t.integer  "sub_sales_area_id"
  end

  create_table "civilities", force: true do |t|
    t.string   "name",       limit: 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published"
  end

  create_table "companies", force: true do |t|
    t.string   "name"
    t.string   "shortcut"
    t.integer  "social_status_id"
    t.string   "trading_identifier"
    t.string   "employees_amount"
    t.string   "capital"
    t.string   "turnover"
    t.string   "phone_number",         limit: 20
    t.string   "fax",                  limit: 20
    t.string   "website"
    t.string   "email"
    t.integer  "country_id"
    t.string   "city"
    t.string   "geographical_address"
    t.string   "postal_address"
    t.integer  "sector_id"
    t.integer  "holding_id"
    t.string   "activities"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "sales_area_id"
    t.boolean  "published"
    t.integer  "created_by"
    t.boolean  "validated_by"
    t.integer  "sub_sales_area_id"
  end

  create_table "countries", force: true do |t|
    t.string   "name"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "formations", force: true do |t|
    t.string   "school",         limit: 100
    t.string   "diploma",        limit: 150
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "adress_book_id"
    t.integer  "user_id"
    t.date     "formation_year"
    t.boolean  "published"
  end

  create_table "forum_posts", force: true do |t|
    t.text     "comment"
    t.boolean  "unpublished"
    t.datetime "unpublished_at"
    t.integer  "unpublished_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "forum_themes_id"
    t.integer  "user_id"
    t.boolean  "published"
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
    t.integer  "user_id"
    t.text     "content"
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

  create_table "hiring_statuses", force: true do |t|
    t.string   "name"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hiring_types", force: true do |t|
    t.string   "name"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hobbies", force: true do |t|
    t.string   "name"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "holdings", force: true do |t|
    t.string   "name"
    t.string   "shortcut"
    t.integer  "number_of_companies"
    t.string   "phone_number",         limit: 16
    t.string   "website"
    t.string   "email"
    t.string   "geographical_address"
    t.string   "postal_address"
    t.integer  "country_id"
    t.string   "city"
    t.text     "activities"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "published"
    t.integer  "created_by"
    t.integer  "validated_by"
  end

  create_table "images", force: true do |t|
    t.string   "alt"
    t.string   "hint"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "information", force: true do |t|
    t.text     "content"
    t.boolean  "published"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_experiences", force: true do |t|
    t.date     "begin_date"
    t.date     "end_date"
    t.string   "company",                limit: 100
    t.integer  "team_members"
    t.string   "role"
    t.integer  "hiring_status_id"
    t.text     "missions"
    t.integer  "hiring_type_id"
    t.string   "predecessor_firstname",  limit: 100
    t.string   "predecessor_lastname",   limit: 100
    t.string   "phone_number",           limit: 16
    t.string   "email",                  limit: 100
    t.string   "superior_firstname",     limit: 100
    t.string   "superior_lastname",      limit: 100
    t.string   "superior_title",         limit: 100
    t.integer  "membership_id"
    t.text     "misc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "adress_book_id"
    t.integer  "user_id"
    t.boolean  "published"
    t.string   "assistant_firstname"
    t.string   "assistant_lastname"
    t.string   "assistant_phone_number"
    t.string   "assistant_email"
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

  create_table "marital_statuses", force: true do |t|
    t.string   "name",       limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", force: true do |t|
    t.string   "name"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "previous_job_experiences", force: true do |t|
    t.date     "begin_date"
    t.date     "end_date"
    t.string   "company_name"
    t.string   "role"
    t.integer  "membership_id"
    t.integer  "user_id"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "adress_book_id"
  end

  create_table "profiles", force: true do |t|
    t.string   "name",       limit: 50
    t.string   "shortcut",   limit: 5
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registrations", force: true do |t|
    t.integer  "user_id"
    t.date     "expires_at"
    t.boolean  "published"
    t.integer  "created_by"
    t.integer  "unpublished_by"
    t.string   "unpublished_at"
    t.string   "datetime"
    t.string   "transaction_id"
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sub_sales_areas", force: true do |t|
    t.string   "name"
    t.boolean  "published"
    t.integer  "sales_area_id"
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
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 10
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "phone_number"
    t.string   "mobile_number"
    t.integer  "profile_id"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "validated_by"
    t.datetime "validated_at"
    t.integer  "unpublished_by"
    t.datetime "unpublished_at"
    t.string   "authentication_token"
    t.string   "company"
    t.string   "job"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
