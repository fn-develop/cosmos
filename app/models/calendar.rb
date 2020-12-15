# == Schema Information
#
# Table name: calendars
#
#  id              :bigint           not null, primary key
#  allday          :boolean          default(FALSE)
#  backgroundcolor :string(255)
#  bordercolor     :string(255)
#  end_day         :integer
#  end_hour        :integer
#  end_minute      :integer
#  end_month       :integer
#  end_year        :integer
#  event_type      :string(255)
#  start_day       :integer
#  start_hour      :integer
#  start_minute    :integer
#  start_month     :integer
#  start_year      :integer
#  title           :string(255)
#  url             :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  company_id      :integer          not null
#  staff_id        :integer          not null
#
class Calendar < ApplicationRecord
  belongs_to :company
  belongs_to :staff, class_name: 'User', required: false

  def has_calendar_event
    cv       = CalendarEvent.new
    cv.id    = self.id.to_s
    cv.title = self.title
    cv.start = get_start
    cv.end   = get_end
    cv.url   = self.url.to_s
    cv.allday = self.allday? ? 'true' : 'false'
    cv.attributes
  end

  private def get_start
    start_dt = "#{ self.start_year.to_s }-#{ self.start_month.to_s }-#{ self.start_day.to_s }"
    start_dt += " #{ self.start_hour.to_s }:#{ self.start_minute.to_s }" if self.start_hour.present? && self.start_minute.present?
    start_dt
  end

  private def get_end
    return '' if self.end_year.blank? || self.end_month.blank? || self.end_day.blank?
    end_dt = "#{ self.end_year.to_s }-#{ self.end_month.to_s }-#{ self.end_day.to_s }"
    end_dt += " #{ self.end_hour.to_s }:#{ self.end_minute.to_s }" if self.end_hour.present? && self.end_minute.present?
    end_dt
  end
end
