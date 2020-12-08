class AddSuccessOrFailureToLineMessageBulkLog < ActiveRecord::Migration[6.0]
  def change
    add_column :line_message_bulk_logs, :success_or_failure, :boolean, default: true, after: :id
    add_column :line_message_bulk_logs, :month, :string, null: false, after: :success_or_failure
    add_column :line_message_bulk_logs, :year, :string, null: false, after: :success_or_failure
    add_column :line_message_bulk_logs, :staff_id, :integer, after: :message

    add_index :line_message_bulk_logs, :year, unique: false
    add_index :line_message_bulk_logs, :month, unique: false
  end
end
