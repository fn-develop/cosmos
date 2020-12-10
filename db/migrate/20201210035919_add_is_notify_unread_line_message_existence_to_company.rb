class AddIsNotifyUnreadLineMessageExistenceToCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :is_notify_unread_line_message_existance, :boolean, default: true, after: :line_channel_token
  end
end
