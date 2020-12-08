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
class LineMessageBulkLog < ApplicationRecord
  serialize :enabled_user_ids, Array
  serialize :disabled_user_ids, Array

  default_value_for :enabled_user_ids, []
  default_value_for :disabled_user_ids, []

  belongs_to :company
  belongs_to :staff, class_name: 'User', required: false

  def enabled_customers
    self.company.customers.where(user_id: self.enabled_user_ids)
  end

  def disabled_customers
    self.company.customers.where(user_id: self.disabled_user_ids)
  end
end
