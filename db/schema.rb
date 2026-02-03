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

ActiveRecord::Schema[8.1].define(version: 2026_02_03_185149) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "saved_items", force: :cascade do |t|
    t.string "clean_url", null: false
    t.datetime "created_at", null: false
    t.string "domain"
    t.string "fetched_title"
    t.datetime "last_viewed_at"
    t.string "metadata_status", default: "pending", null: false
    t.string "state", default: "unread", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "created_at"], name: "index_saved_items_on_user_id_and_created_at", order: { created_at: :desc }
    t.index ["user_id", "url"], name: "index_saved_items_on_user_id_and_url", unique: true
    t.index ["user_id"], name: "index_saved_items_on_user_id"
    t.check_constraint "metadata_status::text = ANY (ARRAY['pending'::character varying, 'succeeded'::character varying, 'failed'::character varying]::text[])", name: "saved_items_metadata_status_allowed"
    t.check_constraint "state::text = ANY (ARRAY['unread'::character varying, 'viewed'::character varying, 'read'::character varying, 'archived'::character varying]::text[])", name: "saved_items_state_allowed"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "saved_items", "users"
  add_foreign_key "sessions", "users"
end
