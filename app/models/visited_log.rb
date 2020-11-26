# == Schema Information
#
# Table name: visited_logs
#
#  id          :bigint           not null, primary key
#  day         :string(255)
#  enabled     :boolean          default(FALSE)
#  month       :string(255)
#  visit_token :string(255)
#  year        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  company_id  :integer          not null
#  customer_id :integer
#
# Indexes
#
#  index_visited_logs_on_company_id  (company_id)
#  index_visited_logs_on_month       (month)
#  index_visited_logs_on_year        (year)
#
class VisitedLog < ApplicationRecord
  belongs_to :company
  belongs_to :customer

  before_create :set_visit_token

  private
    def set_visit_token
      self.visit_token = SecureRandom.urlsafe_base64
    end
end
