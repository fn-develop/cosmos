class CreateSmsLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :sms_logs do |t|
      t.integer :company_id, null: false
      t.integer :customer_id
      t.string  :message
      t.string  :response_code
      t.integer :staff_id, null: false
      t.boolean :checked, default: false

      t.timestamps
    end
  end
end
