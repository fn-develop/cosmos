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

  def self.push_text_message(line_user_id, text_message)
    message = {
      type: 'text',
      text: text_message
    }
    client.push_message(line_user_id, message)
  end

  # LINE Developers登録完了後に作成される環境変数の認証
  def self.client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token  = ENV["LINE_CHANNEL_TOKEN"]
    }
  end
end
