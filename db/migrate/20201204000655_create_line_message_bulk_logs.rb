class CreateLineMessageBulkLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :line_message_bulk_logs do |t|
      t.integer :company_id, null: false
      t.string :message
      t.text :enabled_user_ids, array: true
      t.text :disabled_user_ids, array: true

      t.timestamps
    end

  end
end
