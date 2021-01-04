# == Schema Information
#
# Table name: calendars
#
#  id         :bigint           not null, primary key
#  allday     :string(255)      default("false")
#  color      :string(255)
#  end        :datetime
#  event_type :string(255)
#  site_url   :string(255)
#  start      :datetime
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer          not null
#  staff_id   :integer
#
class Calendar < ApplicationRecord
  belongs_to :company
  belongs_to :staff, class_name: 'User', required: false

  validate :valid_date

  def json_calendar_event
    j                   = {}
    j[:id]              = self.id
    j[:event_type]      = self.event_type
    j[:title]           = self.title
    j[:all_day]         = self.allday
    # JSでは1日目が「0」となるので「-1.day」している
    j[:start]           = self.allday == 'true' ? (self.start - 1.day - 9.hour).strftime("%Y-%m-%d") : (self.start - 1.day - 9.hour).strftime("%Y-%m-%d %H:%M")
    j[:end]             = (self.end - 1.day - 9.hour).strftime("%Y-%m-%d %H:%M") if self.allday == 'false'
    j[:site_url]        = self.site_url.to_s if self.site_url.present?
    j[:color]           = self.color || '#f56954'
    j[:textColor]       = 'white'
    j.to_json
  end

  private def valid_date
    if self.allday == 'false' && self.start >= self.end
      errors.add(:date_range, '終了時刻が開始時刻より前になっています。')
    end
  end
end
