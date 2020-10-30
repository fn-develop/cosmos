class LineMessage
  include ActiveModel::Model
  include ActiveModel::Validations

  # ユーザーID
  attr_accessor :user_id
  # 通知メッセージ
  attr_accessor :message

  validates :user_id, presence: true
  validates :message, presence: true

  def send_text_message
    line_user_id = LineUser.find_by(user_id: self.user_id).line_user_id
    send_message = {
      type: Const::LineMessage::Type::TEXT,
      text: self.message,
    }
    response = client.push_message(line_user_id, send_message)
    response_code = response.code.to_i

    if response_code >= 200 && response_code < 300
      today = Date.today
      LineMessageLog.create(
        company: RequestStore.store[:company],
        user:    self.user_id,
        year:    today.year.to_s,
        month:   today.month.to_s,
        code:    Const::LineMessage::Code::PUSH,
        message: send_message,
        staff:   RequestStore.store[:current_user],
      )
    end
  end

  # LINE Developers登録完了後に作成される環境変数の認証
  def client
    Line::Bot::Client.new { |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token  = ENV['LINE_CHANNEL_TOKEN']
    }
  end
end
