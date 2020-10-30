class AddLineUserIdToLineMessageLogs < ActiveRecord::Migration[6.0]
  def change
    add_column :line_message_logs, :line_user_id, :string, null: true, after: :user_id
    add_index  :line_message_logs, :line_user_id
  end
end
