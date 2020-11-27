# == Schema Information
#
# Table name: companies
#
#  id                      :bigint           not null, primary key
#  code                    :string(255)
#  enabled                 :boolean
#  line_channel_secret     :string(255)
#  line_channel_token      :string(255)
#  line_qr_code            :string(255)
#  logo                    :string(255)
#  name                    :string(255)
#  visit_confirmation_code :string(255)      default("0000")
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
class Company < ApplicationRecord
  mount_uploader :logo, PublicImageUploader
  mount_uploader :line_qr_code, PublicImageUploader

  has_many :users, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :line_message_logs, dependent: :destroy
  has_many :visited_logs, dependent: :destroy

  validates :code, presence: true, uniqueness: true, length: { in: 2..10 }, format: { with: /\A[a-z]+\z/, message: "英文字のみが使用できます" }
  validates :name, presence: true, length: { in: 1..50 }

  after_find :auto_update_visit_confirmation_code

  def get_current_month_push_message_count
    today = Date.today
    year = today.year.to_s
    month = today.month.to_s
    self.line_message_logs.where(
      year: year,
      month: month,
      code: Const::LineMessage::Code::PUSH,
      success_or_failure: true,
    ).size().to_s(:delimited)
  end

  private def auto_update_visit_confirmation_code
    if (DateTime.now.to_i - self.updated_at.to_i) > 24.hour.to_i
      self.visit_confirmation_code = rand(9999).to_s.rjust(4, '0') # 4桁数値文字列を自動生成
      self.save
    end
  end
end
