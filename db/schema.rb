# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_22_102308) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "affiliates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "stripe_price_id_monthly"
    t.string "custom_trial_phase"
    t.string "logo_link"
    t.index ["code"], name: "index_affiliates_on_code"
  end

  create_table "areas", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.uuid "company_id"
    t.index ["company_id"], name: "index_areas_on_company_id"
  end

  create_table "companies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "owner_id"
    t.string "menu_link"
    t.boolean "is_free", default: false
    t.string "privacy_policy_link"
    t.string "street"
    t.string "zip"
    t.string "city"
    t.boolean "need_to_show_corona_test", default: false
    t.index ["owner_id"], name: "index_companies_on_owner_id"
  end

  create_table "data_requests", force: :cascade do |t|
    t.uuid "company_id"
    t.datetime "from"
    t.datetime "to"
    t.datetime "accepted_at"
    t.string "reason"
    t.string "iris_submission_url"
    t.text "iris_health_department"
    t.text "iris_key_of_health_department"
    t.text "iris_key_reference"
    t.index ["accepted_at"], name: "index_data_requests_on_accepted_at"
    t.index ["company_id"], name: "index_data_requests_on_company_id"
  end

  create_table "frontends", force: :cascade do |t|
    t.string "name"
    t.string "url"
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp"
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "owners", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "public_key"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "affiliate"
    t.string "stripe_customer_id"
    t.string "stripe_subscription_id"
    t.datetime "trial_ends_at"
    t.boolean "can_use_for_free", default: false
    t.datetime "block_at"
    t.bigint "frontend_id"
    t.string "api_token"
    t.integer "auto_checkout_minutes"
    t.string "menu_alias"
    t.string "phone"
    t.string "company_name"
    t.string "street"
    t.string "zip"
    t.string "city"
    t.index ["confirmation_token"], name: "index_owners_on_confirmation_token", unique: true
    t.index ["email"], name: "index_owners_on_email", unique: true
    t.index ["frontend_id"], name: "index_owners_on_frontend_id"
    t.index ["reset_password_token"], name: "index_owners_on_reset_password_token", unique: true
  end

  create_table "tickets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "entered_at"
    t.datetime "left_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
    t.string "encrypted_data"
    t.string "public_key"
    t.uuid "area_id"
    t.boolean "accepted_privacy_policy"
    t.index ["area_id"], name: "index_tickets_on_area_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.uuid "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "areas", "companies"
  add_foreign_key "companies", "owners"
  add_foreign_key "data_requests", "companies"
  add_foreign_key "owners", "frontends"
  add_foreign_key "tickets", "areas"
end
