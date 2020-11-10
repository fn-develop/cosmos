class CreateTables < ActiveRecord::Migration[6.0]
  def change
    create_table "collection_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
      t.integer "collection_id"
      t.integer "item_id"
      t.integer "item_type"
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
      t.string "code"
      t.string "name"
      t.boolean "enabled"
      t.string "line_channel_secret"
      t.string "line_channel_token"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end

    create_table "customers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
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
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["company_id"], name: "index_customers_on_company_id"
    end

    create_table "items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
      t.integer "company_id"
      t.string "code"
      t.string "name"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["company_id"], name: "index_items_on_company_id"
    end

    create_table "line_message_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
      t.boolean "success_or_failure", default: true
      t.boolean "checked", default: false
      t.bigint "message_id"
      t.integer "company_id"
      t.string "user_id"
      t.string "line_user_id"
      t.string "message"
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

    create_table "option_for_collection_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
      t.integer "collection_item_id"
      t.string "code"
      t.string "name"
      t.integer "sort_order", limit: 3
      t.boolean "enabled"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
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
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["email"], name: "index_users_on_email"
      t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    end
  end
end
