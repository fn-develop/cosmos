class AddMessageIdToLineMessageLogs < ActiveRecord::Migration[6.0]
  def change
    add_column :line_message_logs, :success_or_failure, :boolean, default: true, after: :id
    add_column :line_message_logs, :checked, :boolean, default: false, after: :success_or_failure
    add_column :line_message_logs, :message_id, :bigint, null: true, after: :checked
  end
end
