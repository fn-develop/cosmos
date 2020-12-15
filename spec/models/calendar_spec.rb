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
require 'rails_helper'

RSpec.describe Calendar, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
