class CreateChatLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_logs do |t|
      t.integer :company_id,   null:    false
      t.integer :user_id
      t.string  :message
      t.string  :image_file
      t.boolean :is_canceled,  default: false

      t.timestamps
    end
  end
end
