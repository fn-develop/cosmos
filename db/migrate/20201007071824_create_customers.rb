class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.integer :user_id
      t.string :name
      t.string :name_kana
      t.integer :gender, limit: 1
      t.string :tel_number
      t.date :birthday
      t.string :postal_code
      t.string :prefecture
      t.string :city
      t.string :address1
      t.string :address2

      t.timestamps
    end
  end
end
