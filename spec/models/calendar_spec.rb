# == Schema Information
#
# Table name: calendars
#
#  id         :bigint           not null, primary key
#  allday     :string(255)      default("false")
#  color      :string(255)
#  end        :datetime
#  event_type :string(255)
#  is_entry   :boolean          default(FALSE)
#  memo       :text(65535)
#  site_url   :string(255)
#  start      :datetime
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer          not null
#  staff_id   :integer
#
require 'rails_helper'

RSpec.describe Calendar, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
