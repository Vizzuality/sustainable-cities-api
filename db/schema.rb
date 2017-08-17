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

ActiveRecord::Schema.define(version: 20170816143846) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "api_keys", force: :cascade do |t|
    t.string "access_token"
    t.datetime "expires_at"
    t.bigint "user_id"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_api_keys_on_access_token", unique: true
    t.index ["user_id"], name: "index_api_keys_on_user_id"
  end

  create_table "attacheable_external_sources", force: :cascade do |t|
    t.integer "external_source_id"
    t.integer "attacheable_id"
    t.string "attacheable_type"
  end

  create_table "bme_categories", force: :cascade do |t|
    t.integer "bme_id"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bme_id"], name: "index_bme_categories_on_bme_id"
    t.index ["category_id"], name: "index_bme_categories_on_category_id"
  end

  create_table "bme_enablings", force: :cascade do |t|
    t.integer "bme_id"
    t.integer "enabling_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bme_id"], name: "index_bme_enablings_on_bme_id"
    t.index ["enabling_id"], name: "index_bme_enablings_on_enabling_id"
  end

  create_table "bmes", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tmp_bme_id"
    t.boolean "is_featured", default: false
    t.string "slug"
    t.boolean "private", default: false
  end

  create_table "business_model_bmes", force: :cascade do |t|
    t.integer "business_model_id"
    t.integer "bme_id"
    t.index ["bme_id", "business_model_id"], name: "index_business_model_bmes_on_bme_id_and_business_model_id", unique: true
  end

  create_table "business_model_enablings", force: :cascade do |t|
    t.integer "business_model_id"
    t.integer "enabling_id"
    t.index ["enabling_id", "business_model_id"], name: "bm_enabling_index", unique: true
  end

  create_table "business_model_users", force: :cascade do |t|
    t.integer "business_model_id"
    t.integer "user_id"
    t.boolean "is_owner", default: false
  end

  create_table "business_models", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "solution_id"
    t.string "link_share"
    t.string "link_edit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "parent_id"
    t.string "category_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "label"
    t.string "slug"
    t.integer "level"
    t.boolean "private", default: false
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.bigint "country_id"
    t.string "iso"
    t.decimal "lat"
    t.decimal "lng"
    t.string "province"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_featured", default: false
    t.index ["country_id"], name: "index_cities_on_country_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id"
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.text "body"
    t.boolean "is_active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_id", "commentable_type"], name: "comments_commentable_index"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "region_name"
    t.string "iso"
    t.string "region_iso"
    t.jsonb "country_centroid"
    t.jsonb "region_centroid"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "documents", force: :cascade do |t|
    t.string "name"
    t.string "attachment"
    t.string "attacheable_type"
    t.bigint "attacheable_id"
    t.boolean "is_active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attacheable_id", "attacheable_type"], name: "documents_attacheable_index"
    t.index ["attacheable_type", "attacheable_id"], name: "index_documents_on_attacheable_type_and_attacheable_id"
  end

  create_table "enablings", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "assessment_value", default: 1
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_featured", default: false
    t.index ["category_id"], name: "index_enablings_on_category_id"
  end

  create_table "external_sources", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "web_url"
    t.string "source_type"
    t.string "author"
    t.datetime "publication_year"
    t.string "institution"
    t.boolean "is_active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
  end

  create_table "impacts", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "impact_value"
    t.string "impact_unit"
    t.bigint "project_id"
    t.bigint "category_id"
    t.boolean "is_active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_impacts_on_category_id"
    t.index ["project_id"], name: "index_impacts_on_project_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id"
    t.string "notificable_type"
    t.bigint "notificable_id"
    t.text "summary"
    t.integer "counter", default: 1
    t.datetime "emailed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notificable_id", "notificable_type"], name: "notifications_notificable_index"
    t.index ["notificable_type", "notificable_id"], name: "index_notifications_on_notificable_type_and_notificable_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "photos", force: :cascade do |t|
    t.string "name"
    t.string "attachment"
    t.string "attacheable_type"
    t.bigint "attacheable_id"
    t.boolean "is_active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attacheable_id", "attacheable_type"], name: "photos_attacheable_index"
    t.index ["attacheable_type", "attacheable_id"], name: "index_photos_on_attacheable_type_and_attacheable_id"
  end

  create_table "project_bmes", force: :cascade do |t|
    t.integer "bme_id"
    t.integer "project_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_featured"
    t.index ["bme_id"], name: "index_project_bmes_on_bme_id"
    t.index ["project_id"], name: "index_project_bmes_on_project_id"
  end

  create_table "project_cities", force: :cascade do |t|
    t.integer "city_id"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_project_cities_on_city_id"
    t.index ["project_id"], name: "index_project_cities_on_project_id"
  end

  create_table "project_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.boolean "is_owner", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_users_on_project_id"
    t.index ["user_id"], name: "index_project_users_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "situation"
    t.text "solution"
    t.bigint "category_id"
    t.integer "country_id"
    t.datetime "operational_year"
    t.integer "project_type"
    t.boolean "is_active", default: false
    t.datetime "deactivated_at"
    t.boolean "publish_request", default: false
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tmp_study_case_id"
    t.boolean "is_featured", default: false
    t.string "tagline"
    t.string "slug"
    t.index ["category_id"], name: "index_projects_on_category_id"
    t.index ["country_id"], name: "index_projects_on_country_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.integer "country_id"
    t.integer "city_id"
    t.string "nickname"
    t.string "name"
    t.string "institution"
    t.string "position"
    t.string "twitter_account"
    t.string "linkedin_account"
    t.boolean "is_active", default: true
    t.datetime "deactivated_at"
    t.string "image"
    t.boolean "notifications_mailer", default: true
    t.integer "notifications_count", default: 0
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "api_keys", "users"
  add_foreign_key "cities", "countries"
  add_foreign_key "comments", "users"
  add_foreign_key "enablings", "categories"
  add_foreign_key "impacts", "categories"
  add_foreign_key "impacts", "projects"
  add_foreign_key "notifications", "users"
  add_foreign_key "projects", "categories"
end
