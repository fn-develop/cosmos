class LineMessage
  include ActiveModel::Model

  # ユーザーID
  attr_accessor :user_id
  # 通知メッセージ
  attr_accessor :message

  def self.push_text_message
    line_user_id = LineUser.find_by(user_id: self.user_id).line_user_id
    send_message = {
      type: Const::LineMessage::Type::TEXT,
      text: self.message,
    }
    client.push_message(line_user_id, send_message)
  end

  # LINE Developers登録完了後に作成される環境変数の認証
  def self.client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token  = ENV['LINE_CHANNEL_TOKEN']
    }
  end
end
