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

  validate :valid_date

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

    def valid_date
      if self.year.blank? || self.month.blank? || self.day.blank?
        errors.add(:visited_date, 'を入力してください。')
      end

      if self.new_record?
        other_visited_log = self.customer.visited_logs.find_by(year: self.year, month: self.month, day: self.day, enabled: true)
      end

      # 新規作成の場合は同じ日付のレコードある場合重複NG、更新の場合は「同じ日付」かつ「違うID」が存在した場合重複NG
      if (self.new_record? && other_visited_log.present?) || (other_visited_log.try(:id).present? && other_visited_log.try(:id) != self.id)
        errors.add(:visited_date, 'は既に登録済です。')
      elsif !Date.valid_date?(self.year.to_i, self.month.to_i, self.day.to_i)
        errors.add(:visited_date, 'に正しい日付を入力してください。')
      end
    end
end
