class AddIsSmsFeatureToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :is_sms_feature, :boolean, default: false, after: :line_channel_token
    add_column :companies, :limit_sms_message_count, :integer, default: 0, after: :is_sms_feature
    add_column :companies, :sms_tel_number, :string, after: :limit_sms_message_count
  end
end
