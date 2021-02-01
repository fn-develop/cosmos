class LineMessageBulk
  include ActiveModel::Model
  include ActiveModel::Validations

  # 会社
  attr_accessor :company
  # ユーザーID(複数)
  attr_accessor :user_ids
  # 通知メッセージ
  attr_accessor :message

  validates :company, presence: true
  validates :user_ids, presence: true
  validates :message, presence: true

  def send_multicast_text_message
    enabled_users  = self.company.users.where(id: user_ids).where('line_user_id IS NOT NULL')
    disabled_users = self.company.users.where(id: user_ids).where('line_user_id IS NULL')

    send_message = {
     type: Const::LineMessage::Type::TEXT,
     text: self.message,
    }

    response = client.multicast(enabled_users.pluck(:line_user_id).uniq, send_message)
    response_code = response.code.to_i

    today = Date.today
    lmbl = company.line_message_bulk_logs.new(
      company:            RequestStore.store[:company],
      year:               today.year.to_s,
      month:              today.month.to_s,
      message:            message,
      enabled_user_ids:   enabled_users.pluck(:id).uniq,
      disabled_user_ids:  disabled_users.pluck(:id).uniq,
      staff:              RequestStore.store[:current_user],
      success_or_failure: (response_code >= 200 && response_code < 300),
    )

    lmbl.save

    enabled_users.each do | user |
      LineMessageLog.new(
        company:      RequestStore.store[:company],
        user_id:      user.id,
        line_user_id: user.line_user_id,
        year:         today.year.to_s,
        month:        today.month.to_s,
        code:         Const::LineMessage::Code::PUSH,
        message:      message,
        staff:        RequestStore.store[:current_user],
        checked:      true,
      ).save
    end

    line_message_count_ar = self.company.line_message_counts.find_or_initialize_by(year: today.year.to_s, month: today.month.to_s)

    if lmbl.success_or_failure
      total_usage = client.get_message_quota_consumption.try(:body)
      total = JSON.parse(total_usage)['totalUsage'] if total_usage.present?
      line_message_count_ar.total = total || 99999
      line_message_count_ar.save
    end

    return lmbl.success_or_failure
  end

  # LINE Developers登録完了後に作成される環境変数の認証
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = self.company.try(:line_channel_secret)
      config.channel_token  = self.company.try(:line_channel_token)
    }
  end
end
