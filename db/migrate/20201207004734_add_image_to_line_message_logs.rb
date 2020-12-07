class AddImageToLineMessageLogs < ActiveRecord::Migration[6.0]
  def change
    add_column :line_message_logs, :message_type, :string, after: :line_user_id, default: Const::LineMessage::Type::TEXT
    add_column :line_message_logs, :image, :string, after: :message
  end
end
