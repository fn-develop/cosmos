# == Schema Information
#
# Table name: calendars
#
#  id         :bigint           not null, primary key
#  allday     :string(255)      default("false")
#  end        :datetime
#  event_type :string(255)
#  start      :datetime
#  title      :string(255)
#  url        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer          not null
#  staff_id   :integer
#
class Calendar < ApplicationRecord
  belongs_to :company
  belongs_to :staff, class_name: 'User', required: false

  EVENT_TYPES = [:store_holiday, :holiday, :event].freeze

  def self.event_type_arr
    EVENT_TYPES.map{ |v| [I18n.t("common.event_types.#{v}"), v] }
  end

  def json_calendar_event
    j = {}
    j[:id]      = self.id
    j[:title]   = self.title
    j[:all_day] = self.allday
    # JSでは1日目が「0」となるので「-1.day」している
    j[:start]   = self.allday == 'true' ? (self.start - 1.day).strftime("%Y-%m-%d") : (self.start - 1.day).strftime("%Y-%m-%d %H:%M")
    j[:end]     = (self.end - 1.day).strftime("%Y-%m-%d %H:%M") if self.allday == 'false'
    j[:url]     = self.url.to_s if self.url.present?
    j[:backgroundcolor] = '#f56954'
    j[:bordercolor]     = '#f56954'
    j.to_json
  end

  # private def get_start
  #   start_dt = "#{ self.start_year.to_s }-#{ self.start_month.to_s }-#{ self.start_day.to_s }"
  #   start_dt += " #{ self.start_hour.to_s }:#{ self.start_minute.to_s }" if self.start_hour.present? && self.start_minute.present?
  #   start_dt
  # end

  # private def get_end
  #   return '' if self.end_year.blank? || self.end_month.blank? || self.end_day.blank?
  #   end_dt = "#{ self.end_year.to_s }-#{ self.end_month.to_s }-#{ self.end_day.to_s }"
  #   end_dt += " #{ self.end_hour.to_s }:#{ self.end_minute.to_s }" if self.end_hour.present? && self.end_minute.present?
  #   end_dt
  # end
end
