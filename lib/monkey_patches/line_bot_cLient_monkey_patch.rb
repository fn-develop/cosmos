require 'line-bot-api'

module LineBotCLientMonkeyPatch
  # LINEメッセージ送信数取得
  def get_message_quota_consumption
    channel_token_required

    endpoint_path = "/bot/message/quota/consumption"
    get(endpoint, endpoint_path, credentials)
  end
end

Line::Bot::Client.prepend(LineBotCLientMonkeyPatch)
