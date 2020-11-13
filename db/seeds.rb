# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# User.create(email: 'admin@example.com', role: :system_admin, password: 12345678, company: Company.find_by(code: 'demo') )
Company.delete_all
ActiveRecord::Base.connection.execute('ALTER TABLE companies AUTO_INCREMENT = 1')
demo_company = Company.create(code: 'demo', name: 'DEMO会社', enabled: true)

Item.delete_all
ActiveRecord::Base.connection.execute('ALTER TABLE items AUTO_INCREMENT = 1')
item_name_kanji          = demo_company.items.create(code: 'name_kanji', name: 'ユーザー名')
item_name_kana           = demo_company.items.create(code: 'name_kana', name: 'ユーザー名（カナ）')
item_phone_number        = demo_company.items.create(code: 'phone_number', name: '固定電話番号')
item_mobile_phone_number = demo_company.items.create(code: 'mobile_phone_number', name: '携帯電話番号')
item_gender              = demo_company.items.create(code: 'gender', name: '性別')
item_birthday            = demo_company.items.create(code: 'birthday', name: '生年月日')
item_postal_code         = demo_company.items.create(code: 'postal_code', name: '郵便番号')
item_prefecture          = demo_company.items.create(code: 'prefecture', name: '都道府県')
item_city                = demo_company.items.create(code: 'city', name: '市区町村')
item_address1            = demo_company.items.create(code: 'address1', name: '番地')
item_address2            = demo_company.items.create(code: 'address2', name: '建物名・号室')

Collection.delete_all
ActiveRecord::Base.connection.execute('ALTER TABLE collections AUTO_INCREMENT = 1')
collection = demo_company.collections.create(code: 'customer', name: '顧客情報', sort_order: 0, enabled: true)

CollectionItem.delete_all
ActiveRecord::Base.connection.execute('ALTER TABLE collection_items AUTO_INCREMENT = 1')
[
  { item: item_name_kanji          , item_type: Const::CollectionItem::ItemType::TEXT, sort_order: 0, enabled: true },
  { item: item_name_kana           , item_type: Const::CollectionItem::ItemType::TEXT, sort_order: 1, enabled: true },
  { item: item_phone_number        , item_type: Const::CollectionItem::ItemType::TEXT, sort_order: 2, enabled: true },
  { item: item_mobile_phone_number , item_type: Const::CollectionItem::ItemType::TEXT, sort_order: 3, enabled: true },
  { item: item_gender              , item_type: Const::CollectionItem::ItemType::RADIO, sort_order: 4, enabled: true },
  { item: item_birthday            , item_type: Const::CollectionItem::ItemType::DATE, sort_order: 5, enabled: true },
  { item: item_postal_code         , item_type: Const::CollectionItem::ItemType::TEXT, sort_order: 6, enabled: true },
  { item: item_prefecture          , item_type: Const::CollectionItem::ItemType::TEXT, sort_order: 7, enabled: true },
  { item: item_city                , item_type: Const::CollectionItem::ItemType::TEXT, sort_order: 8, enabled: true },
  { item: item_address1            , item_type: Const::CollectionItem::ItemType::TEXT, sort_order: 9, enabled: true },
  { item: item_address2            , item_type: Const::CollectionItem::ItemType::TEXT, sort_order: 10, enabled: true },
].each { |rel| collection.collection_items.create(rel) }

OptionForCollectionItem.delete_all
ActiveRecord::Base.connection.execute('ALTER TABLE option_for_collection_items AUTO_INCREMENT = 1')
collection_item_gender = item_gender.collection_items.first
collection_item_gender.option_for_collection_items.create(code: 'woman', name: '女性', sort_order: 0, enabled: true)
collection_item_gender.option_for_collection_items.create(code: 'man', name: '男性', sort_order: 1, enabled: true)
