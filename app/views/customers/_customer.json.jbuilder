json.extract! customer, :id, :name, :name_kana, :gender, :tel_number, :birthday, :postal_code, :prefecture, :city, :address1, :address2, :created_at, :updated_at
json.url customer_url(customer, format: :json)
