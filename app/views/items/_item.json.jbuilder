json.extract! item, :id, :code, :name, :sort_order, :created_at, :updated_at
json.url item_url(item, format: :json)
