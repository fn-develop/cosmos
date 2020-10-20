# == Schema Information
#
# Table name: line_users
#
#  id           :bigint           not null, primary key
#  reply_token  :string(255)
#  request_json :text(65535)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  company_id   :integer
#  line_user_id :string(255)
#  user_id      :integer
#
class LineUser < ApplicationRecord
  belongs_to :user, required: false
  belongs_to :company, required: false
end
