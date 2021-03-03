# == Schema Information
#
# Table name: app_settings
#
#  id                      :bigint           not null, primary key
#  management_company_name :string(255)      default("")
#  privacy_policy          :text(65535)
#  sms_cancel_api_url      :string(255)
#  sms_result_api_url      :string(255)
#  sms_send_api_url        :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
FactoryBot.define do
  factory :app_setting do
    
  end
end
