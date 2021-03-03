# == Schema Information
#
# Table name: sms_logs
#
#  id            :bigint           not null, primary key
#  checked       :boolean          default(FALSE)
#  message       :string(255)
#  response_code :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  company_id    :integer          not null
#  customer_id   :integer
#  staff_id      :integer          not null
#
class SmsLog < ApplicationRecord
  belongs_to :company
  belongs_to :customer, required: false
  belongs_to :staff, class_name: 'User', required: false
end
