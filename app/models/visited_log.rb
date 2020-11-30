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
  before_save :rjust_month_and_day

  attr_accessor :visit_confirmation_code

  def route
    { company_code: self.company.try(:code), customer_id: self.customer.try(:id) }.merge(self.attributes)
  end

  def visited?
    today = Date.today
    self.company.visited_logs.find_by(customer: self.customer, year: today.year.to_s, month: today.month.to_s, day: today.day.to_s, enabled: true).present?
  end

  def visited_day
    "#{ self.year }年#{ self.month }月#{ self.day }日"
  end

  private
    def set_visit_token
      self.visit_token = SecureRandom.urlsafe_base64
    end

    def rjust_month_and_day
      self.month = self.month.rjust(2, '0')
      self.day = self.day.rjust(2, '0')
    end
end
