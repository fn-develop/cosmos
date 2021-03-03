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
class AppSetting < ApplicationRecord
  REGISTER_LIMIT_COUNT = 1 # 定数として登録数を管理
  validate :limit_register_count, on: :create  # 作成したメソッドでバリデーション
  validates :management_company_name, presence: true, length: { in: 1..200 }
  validates :privacy_policy, presence: true

  private def limit_register_count
    if AppSetting.count >= REGISTER_LIMIT_COUNT # レコード数が制限を超えている
      errors.add(:user, "count is over") # エラーを追加
    end
  end
end
