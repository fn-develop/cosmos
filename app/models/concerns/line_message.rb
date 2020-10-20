class LineMessage
  include ActiveModel::Model

  # 顧客情報
  attr_accessor :customer
  # 通知メッセージ
  attr_accessor :message
end
