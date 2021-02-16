# == Schema Information
#
# Table name: chat_logs
#
#  id          :bigint           not null, primary key
#  image_file  :string(255)
#  is_canceled :boolean          default(FALSE)
#  message     :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  company_id  :integer          not null
#  user_id     :integer
#
require 'rails_helper'

RSpec.describe ChatLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
