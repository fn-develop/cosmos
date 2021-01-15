# == Schema Information
#
# Table name: calendars
#
#  id         :bigint           not null, primary key
#  allday     :string(255)      default("false")
#  color      :string(255)
#  end        :datetime
#  event_type :string(255)
#  memo       :text(65535)
#  site_url   :string(255)
#  start      :datetime
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer          not null
#  staff_id   :integer
#
FactoryBot.define do
  factory :calendar do
    
  end
end
