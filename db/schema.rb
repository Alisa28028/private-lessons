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

ActiveRecord::Schema[7.1].define(version: 2025_08_14_092422) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
    t.index ["visitor_token", "started_at"], name: "index_ahoy_visits_on_visitor_token_and_started_at"
  end

  create_table "bookings", force: :cascade do |t|
    t.string "state", default: "unpaid"
    t.string "checkout_session_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "event_instance_id"
    t.boolean "waitlisted", default: false, null: false
    t.datetime "joined_at"
    t.string "status"
    t.string "cancelled_by"
    t.datetime "cancelled_at"
    t.index ["user_id", "event_instance_id"], name: "index_bookings_on_user_and_event_instance_active_only", unique: true, where: "((status)::text <> ALL ((ARRAY['cancelled_by_student'::character varying, 'cancelled_by_teacher'::character varying])::text[]))"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "event_instances", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "start_time"
    t.datetime "end_time"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "duration"
    t.integer "capacity"
    t.integer "cancellation_policy_duration"
    t.integer "price_cents", default: 0, null: false
    t.bigint "location_id"
    t.string "approval_mode"
    t.index ["event_id"], name: "index_event_instances_on_event_id"
    t.index ["location_id"], name: "index_event_instances_on_location_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "capacity"
    t.bigint "user_id", null: false
    t.bigint "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_cents", default: 0, null: false
    t.time "start_time"
    t.time "end_time"
    t.text "custom_dates"
    t.string "day_of_week"
    t.integer "default_capacity", default: 10, null: false
    t.integer "cancellation_policy_duration"
    t.integer "duration"
    t.string "recurrence_type"
    t.string "time_zone"
    t.string "approval_mode"
    t.boolean "payment_obligation_on_booking"
    t.index ["location_id"], name: "index_events_on_location_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_instance_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_instance_id"], name: "index_likes_on_event_instance_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "location_id", null: false
    t.index ["location_id"], name: "index_locations_users_on_location_id"
    t.index ["user_id"], name: "index_locations_users_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "content"
    t.boolean "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "event_id"
    t.string "title"
    t.integer "event_instance_id"
    t.boolean "hidden"
    t.index ["event_id"], name: "index_posts_on_event_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "studios", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.boolean "is_teacher"
    t.string "description"
    t.string "phone_number"
    t.string "time_zone"
    t.string "instagram"
    t.string "x"
    t.string "tiktok"
    t.string "dashboard_preference"
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "event_instance_id", null: false
    t.bigint "user_id", null: false
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_videos_on_event_id"
    t.index ["event_instance_id"], name: "index_videos_on_event_instance_id"
    t.index ["user_id"], name: "index_videos_on_user_id"
  end

  create_table "weekly_availabilities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "day", null: false
    t.time "start_time", null: false
    t.time "end_time", null: false
    t.string "style", null: false
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "studio_id"
    t.index ["studio_id"], name: "index_weekly_availabilities_on_studio_id"
    t.index ["user_id"], name: "index_weekly_availabilities_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookings", "users"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "event_instances", "events"
  add_foreign_key "event_instances", "locations"
  add_foreign_key "events", "locations"
  add_foreign_key "events", "users"
  add_foreign_key "likes", "event_instances"
  add_foreign_key "likes", "users"
  add_foreign_key "locations_users", "locations"
  add_foreign_key "locations_users", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "posts", "events"
  add_foreign_key "posts", "users"
  add_foreign_key "videos", "event_instances"
  add_foreign_key "videos", "events"
  add_foreign_key "videos", "users"
  add_foreign_key "weekly_availabilities", "studios"
  add_foreign_key "weekly_availabilities", "users"
end
