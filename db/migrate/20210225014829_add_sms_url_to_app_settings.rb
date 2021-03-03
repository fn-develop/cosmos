class AddSmsUrlToAppSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :app_settings, :sms_send_api_url, :string, after: :privacy_policy
    add_column :app_settings, :sms_result_api_url, :string, after: :sms_send_api_url
    add_column :app_settings, :sms_cancel_api_url, :string, after: :sms_result_api_url
  end
end
