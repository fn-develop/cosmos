# == Schema Information
#
# Table name: line_message_bulk_logs
#
#  id                 :bigint           not null, primary key
#  disabled_user_ids  :text(65535)
#  enabled_user_ids   :text(65535)
#  message            :string(255)
#  month              :string(255)      not null
#  success_or_failure :boolean          default(TRUE)
#  year               :string(255)      not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  company_id         :integer          not null
#  staff_id           :integer
#
# Indexes
#
#  index_line_message_bulk_logs_on_company_id  (company_id)
#  index_line_message_bulk_logs_on_month       (month)
#  index_line_message_bulk_logs_on_year        (year)
#
require 'rails_helper'

RSpec.describe LineMessageBulkLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
