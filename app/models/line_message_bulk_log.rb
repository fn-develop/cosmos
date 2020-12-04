# == Schema Information
#
# Table name: line_message_bulk_logs
#
#  id                :bigint           not null, primary key
#  disabled_user_ids :text(65535)
#  enabled_user_ids  :text(65535)
#  message           :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  company_id        :integer          not null
#
class LineMessageBulkLog < ApplicationRecord
  serialize :enabled_user_ids, Array
  serialize :disabled_user_ids, Array

  default_value_for :enabled_user_ids, []
  default_value_for :disabled_user_ids, []

  belongs_to :company

  def enabled_customers
    self.company.customers.where(user_id: self.enabled_user_ids)
  end

  def disabled_customers
    self.company.customers.where(user_id: self.disabled_user_ids)
  end
end
