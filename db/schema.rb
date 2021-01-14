# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_14_022319) do

  create_table "app_settings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "management_company_name", default: ""
    t.text "privacy_policy"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "calendar_settings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "company_id", null: false
    t.boolean "is_open", default: false
    t.text "open_collection_item_ids"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "calendars", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "company_id", null: false
    t.string "title"
    t.string "color"
    t.datetime "start"
    t.datetime "end"
    t.string "allday", default: "false"
    t.string "site_url"
    t.string "event_type"
    t.integer "staff_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "collection_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "item_id"
    t.string "key"
    t.string "value"
    t.integer "sort_order", limit: 3
    t.boolean "enabled"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "collections", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "company_id"
    t.string "code"
    t.string "name"
    t.integer "sort_order", limit: 3
    t.boolean "enabled"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_collections_on_company_id"
  end

  create_table "companies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "type_for", default: ""
    t.string "code"
    t.string "name"
    t.boolean "enabled"
    t.string "logo"
    t.integer "limit_line_message_count", default: 1000
    t.string "visit_confirmation_code", default: "0000"
    t.string "line_qr_code"
    t.string "line_channel_secret"
    t.string "line_channel_token"
    t.boolean "is_for_profit", default: true
    t.boolean "is_calendar_feature", default: false
    t.boolean "is_notify_unread_line_message_existance", default: true
    t.boolean "is_inviting_feature", default: true
    t.boolean "is_input_customer_name", default: true
    t.boolean "is_input_customer_name_kana", default: true
    t.boolean "is_input_customer_gender", default: true
    t.boolean "is_input_customer_tel_number", default: true
    t.boolean "is_input_customer_birthday", default: true
    t.boolean "is_input_customer_address", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "customers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.boolean "agreement", default: false
    t.integer "introducer_id"
    t.string "invite_code"
    t.integer "company_id", null: false
    t.integer "user_id"
    t.string "name"
    t.string "name_kana"
    t.integer "gender", limit: 1
    t.string "tel_number"
    t.date "birthday"
    t.string "postal_code"
    t.string "prefecture"
    t.string "city"
    t.string "address1"
    t.string "address2"
    t.integer "ymd_num"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_customers_on_company_id"
  end

  create_table "items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "company_id"
    t.string "code"
    t.string "sub_code"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_items_on_company_id"
  end

  create_table "line_message_bulk_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.boolean "success_or_failure", default: true
    t.string "year", null: false
    t.string "month", null: false
    t.integer "company_id", null: false
    t.string "message"
    t.integer "staff_id"
    t.text "enabled_user_ids"
    t.text "disabled_user_ids"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_line_message_bulk_logs_on_company_id"
    t.index ["month"], name: "index_line_message_bulk_logs_on_month"
    t.index ["year"], name: "index_line_message_bulk_logs_on_year"
  end

  create_table "line_message_counts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "company_id", null: false
    t.integer "total", null: false
    t.string "year", null: false
    t.string "month", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "line_message_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.boolean "success_or_failure", default: true
    t.boolean "checked", default: false
    t.bigint "message_id"
    t.integer "company_id"
    t.string "user_id"
    t.string "line_user_id"
    t.string "message_type", default: "text"
    t.string "message"
    t.string "image"
    t.string "code"
    t.string "year"
    t.string "month"
    t.integer "staff_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_line_message_logs_on_code"
    t.index ["company_id", "user_id"], name: "index_line_message_logs_on_company_id_and_user_id"
    t.index ["line_user_id"], name: "index_line_message_logs_on_line_user_id"
    t.index ["year", "month"], name: "index_line_message_logs_on_year_and_month"
  end

  create_table "line_message_notify_settings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "company_id", null: false
    t.boolean "notify_enabled", default: true
    t.integer "norify_time_from", default: 0
    t.integer "norify_time_to", default: 0
    t.integer "notify_cycle", default: 0
    t.string "notify_target"
    t.string "auto_message_on_time", default: ""
    t.string "auto_message_off_time", default: ""
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "option_for_collection_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "collection_item_id"
    t.string "code"
    t.string "name"
    t.integer "sort_order", limit: 3
    t.boolean "enabled"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "item_type"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "company_id", null: false
    t.integer "role", limit: 1, default: 0, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "line_user_id"
    t.string "line_display_name"
    t.string "line_image_url"
    t.string "line_status_message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "visited_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "company_id", null: false
    t.integer "customer_id"
    t.string "year"
    t.string "month"
    t.string "day"
    t.string "visit_token"
    t.boolean "enabled", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_visited_logs_on_company_id"
    t.index ["month"], name: "index_visited_logs_on_month"
    t.index ["year"], name: "index_visited_logs_on_year"
  end

end
