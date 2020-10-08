json.extract! collection_item, :id, :collection_id, :item_id, :item_type, :sort_order, :enabled, :created_at, :updated_at
json.url collection_item_url(collection_item, format: :json)
