# == Schema Information
#
# Table name: companies
#
#  id                                      :bigint           not null, primary key
#  code                                    :string(255)
#  enabled                                 :boolean
#  is_calendar_feature                     :boolean          default(FALSE)
#  is_chat_feature                         :boolean          default(FALSE)
#  is_for_profit                           :boolean          default(TRUE)
#  is_input_customer_address               :boolean          default(TRUE)
#  is_input_customer_birthday              :boolean          default(TRUE)
#  is_input_customer_gender                :boolean          default(TRUE)
#  is_input_customer_name                  :boolean          default(TRUE)
#  is_input_customer_name_kana             :boolean          default(TRUE)
#  is_input_customer_tel_number            :boolean          default(TRUE)
#  is_inviting_feature                     :boolean          default(TRUE)
#  is_notify_unread_line_message_existance :boolean          default(TRUE)
#  limit_line_message_count                :integer          default(1000)
#  line_channel_secret                     :string(255)
#  line_channel_token                      :string(255)
#  line_qr_code                            :string(255)
#  logo                                    :string(255)
#  name                                    :string(255)
#  type_for                                :string(255)      default("")
#  visit_confirmation_code                 :string(255)      default("0000")
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
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
  has_many :line_message_bulk_logs, dependent: :destroy
  has_many :line_message_counts, dependent: :destroy
  has_one :line_message_notify_setting, dependent: :destroy
  has_many :calendars, dependent: :destroy
  has_one :calendar_setting, dependent: :destroy
  has_many :line_richmenu_images, dependent: :destroy
  has_many :chat_logs, dependent: :destroy

  validates :code, presence: true, uniqueness: true, length: { in: 2..10 }, format: { with: /\A[a-z]+\z/, message: "英文字のみが使用できます" }
  validates :name, presence: true, length: { in: 1..50 }

  def within_limit_line_message?
    get_current_month_line_message_count < self.limit_line_message_count
  end

  def get_current_month_line_message_count
    today = Date.today
    line_message_count = self.line_message_counts.find_by(year: today.year.to_s, month: today.month.to_s)
    line_message_count.try(:total) || 0
  end

  def calendar_open_event_types
    @calendar_open_event_types ||= CollectionItem.where(id: self.calendar_setting.open_collection_item_ids.to_a).pluck(:value)
  end

  def calendar_event_types
    item = self.items.find_by(code: Const::Item::Code::CALENDAR, sub_code: Const::Item::SubCode::SELECT_OPTION)
    if item && item.collection_items
      return item.collection_items.map{ |ci| [ci.key, ci.value] }
    else
      return []
    end
  end
end
