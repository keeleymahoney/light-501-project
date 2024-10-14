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

ActiveRecord::Schema[7.0].define(version: 2024_10_13_161958) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.binary "pfp"
    t.boolean "in_network", default: false
  end

  create_table "contacts_industries", force: :cascade do |t|
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
  end

  create_table "industries", force: :cascade do |t|
    t.string "industry_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members", force: :cascade do |t|
    t.string "email", null: false
    t.string "full_name"
    t.string "uid"
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_members_on_email", unique: true
  end

  create_table "tokens", force: :cascade do |t|
    t.text "access_token"
    t.text "token_exp"
    t.bigint "member_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_tokens_on_member_id"
  end

  create_table "requests", force: :cascade do |t|
    t.integer "status", default: 0
    t.bigint "member_id", null: false
    t.integer "request_type", default: 0
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_requests_on_member_id"
  end

  add_foreign_key "contacts_industries", "contacts"
  add_foreign_key "contacts_industries", "industries"
  add_foreign_key "event_images", "events"
  add_foreign_key "tokens", "members"
  add_foreign_key "requests", "members"
end
