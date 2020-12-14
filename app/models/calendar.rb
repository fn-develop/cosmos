# == Schema Information
#
# Table name: calendars
#
#  id             :bigint           not null, primary key
#  day            :string(255)      not null
#  end_datetime   :datetime
#  month          :string(255)      not null
#  start_datetime :datetime
#  type           :integer          not null
#  year           :string(255)      not null
#  ymd_num        :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  company_id     :integer          not null
#  staff_id       :integer          not null
#
class Calendar < ApplicationRecord
end
