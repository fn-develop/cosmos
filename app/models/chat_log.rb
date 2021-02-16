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
class ChatLog < ApplicationRecord
  belongs_to :company
  belongs_to :user
end
