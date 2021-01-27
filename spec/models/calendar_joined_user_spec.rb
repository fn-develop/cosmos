# == Schema Information
#
# Table name: calendar_joined_users
#
#  id          :bigint           not null, primary key
#  comment     :string(255)
#  is_join     :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  calendar_id :integer          not null
#  user_id     :integer          not null
#
require 'rails_helper'

RSpec.describe CalendarJoinedUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
