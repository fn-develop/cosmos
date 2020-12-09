class AddSomeFlgToCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :is_input_customer_name,       :boolean, default: true, after: :line_channel_token
    add_column :companies, :is_input_customer_name_kana,  :boolean, default: true, after: :is_input_customer_name
    add_column :companies, :is_input_customer_gender,     :boolean, default: true, after: :is_input_customer_name_kana
    add_column :companies, :is_input_customer_tel_number, :boolean, default: true, after: :is_input_customer_gender
    add_column :companies, :is_input_customer_birthday,   :boolean, default: true, after: :is_input_customer_tel_number
    add_column :companies, :is_input_customer_address,    :boolean, default: true, after: :is_input_customer_birthday
  end
end
