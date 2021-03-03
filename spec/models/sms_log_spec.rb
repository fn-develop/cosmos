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
require 'rails_helper'

RSpec.describe SmsLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
