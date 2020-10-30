class CreateLineMessageLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :line_message_logs  do |t|
      t.integer :company_id
      t.string  :user_id
      t.string  :message
      t.string  :code
      t.string  :year
      t.string  :month
      t.integer :staff_id

      t.timestamps
    end

    add_index :line_message_logs, [:company_id, :user_id], unique: false
    add_index :line_message_logs, :code
    add_index :line_message_logs, [:year, :month], unique: false
  end
end
