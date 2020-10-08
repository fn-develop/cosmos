json.extract! option_for_item, :id, :item_id, :item_type, :code, :name, :sort_order, :enabled, :created_at, :updated_at
json.url option_for_item_url(option_for_item, format: :json)
