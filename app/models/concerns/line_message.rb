class LineMessage
  include ActiveModel::Model
  include ActiveModel::Validations

  # ユーザーID
  attr_accessor :user_id
  # 通知メッセージ
  attr_accessor :message
  # 会社
  attr_accessor :company

  validates :user_id, presence: true
  validates :message, presence: true

  def send_text_message
    line_user_id = User.find(self.user_id).line_user_id
    send_message = {
      type: Const::LineMessage::Type::TEXT,
      text: self.message,
    }
    response = client.push_message(line_user_id, send_message)
    response_code = response.code.to_i

    today = Date.today
    lml = LineMessageLog.new(
      company:      RequestStore.store[:company],
      user_id:      self.user_id,
      line_user_id: line_user_id,
      year:         today.year.to_s,
      month:        today.month.to_s,
      code:         Const::LineMessage::Code::PUSH,
      message:      self.message,
      staff:        RequestStore.store[:current_user],
      checked:      true,
    )

    lml.success_or_failure = (response_code >= 200 && response_code < 300)
    lml.save

    line_message_count_ar = self.company.line_message_counts.find_or_initialize_by(year: today.year.to_s, month: today.month.to_s)

    if lml.success_or_failure
      total_usage = client.get_message_quota_consumption.try(:body)
      total = JSON.parse(total_usage)['totalUsage'] if total_usage.present?
      line_message_count_ar.total = total || 99999
      line_message_count_ar.save
    end

    return lml.success_or_failure
  end

  # LINE Developers登録完了後に作成される環境変数の認証
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = self.company.try(:line_channel_secret)
      config.channel_token  = self.company.try(:line_channel_token)
    }
  end
end
