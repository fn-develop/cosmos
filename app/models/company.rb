# == Schema Information
#
# Table name: companies
#
#  id                  :bigint           not null, primary key
#  code                :string(255)
#  enabled             :boolean
#  line_channel_secret :string(255)
#  line_channel_token  :string(255)
#  line_qr_code        :string(255)
#  logo                :string(255)
#  name                :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class Company < ApplicationRecord
  mount_uploader :logo, PublicImageUploader

  has_many :users, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :line_message_logs

  validates :code, presence: true, uniqueness: true, length: { in: 2..10 }, format: { with: /\A[a-z]+\z/, message: "英文字のみが使用できます" }
  validates :name, presence: true, length: { in: 1..50 }

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
end
