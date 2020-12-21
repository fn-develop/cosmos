class AddAutoMessagesToLineMessageNotifySettings < ActiveRecord::Migration[6.0]
  def change
    add_column :line_message_notify_settings, :auto_message_on_time,  :string, default: '', after: :notify_target
    add_column :line_message_notify_settings, :auto_message_off_time, :string, default: '', after: :auto_message_on_time
  end
end
