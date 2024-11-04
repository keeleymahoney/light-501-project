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

ActiveRecord::Schema[7.0].define(version: 2024_10_30_163430) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "contacts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "organization"
    t.string "title"
    t.string "link"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "in_network", default: false
  end

  create_table "contacts_industries", id: false, force: :cascade do |t|
    t.bigint "contact_id", null: false
    t.bigint "industry_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_contacts_industries_on_contact_id"
    t.index ["industry_id"], name: "index_contacts_industries_on_industry_id"
  end

  create_table "event_images", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.binary "picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_images_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.datetime "date"
    t.text "description"
    t.text "location"
    t.text "rsvp_link"
    t.text "feedback_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "virtual"
    t.boolean "published"
  end

  create_table "industries", force: :cascade do |t|
    t.string "industry_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members", force: :cascade do |t|
    t.integer "contact_id", null: false
    t.string "email", null: false
    t.string "full_name"
    t.boolean "admin", default: false
    t.datetime "network_exp"
    t.datetime "constitution_exp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_members_on_contact_id"
    t.index ["email"], name: "index_members_on_email", unique: true
  end

  create_table "requests", force: :cascade do |t|
    t.integer "status", default: 0
    t.bigint "member_id", null: false
    t.integer "request_type", default: 0
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "contacts_id"
    t.index ["contacts_id"], name: "index_requests_on_contacts_id"
    t.index ["member_id"], name: "index_requests_on_member_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.text "access_token"
    t.text "token_exp"
    t.bigint "member_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_tokens_on_member_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "contacts_industries", "contacts"
  add_foreign_key "contacts_industries", "industries"
  add_foreign_key "event_images", "events"
  add_foreign_key "members", "contacts"
  add_foreign_key "requests", "members"
  add_foreign_key "tokens", "members"
end
