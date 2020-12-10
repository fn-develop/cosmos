# == Schema Information
#
# Table name: line_message_notify_settings
#
#  id               :bigint           not null, primary key
#  norify_time_from :integer          default(0)
#  norify_time_to   :integer          default(0)
#  notify_cycle     :integer          default(0)
#  notify_enabled   :boolean          default(TRUE)
#  notify_target    :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  company_id       :integer          not null
#
class LineMessageNotifySetting < ApplicationRecord
  belongs_to :company

  NOTIFY_CYCLE = { '都度': 1, '10分': 10, '30分': 30, '1時間': 60 }
  NOTIFY_TAEGET = { 'オーナー': 'owner', 'スタッフ': 'staff', '両方': 'all' }
end
