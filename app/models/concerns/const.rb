module Const
  module CollectionItem
    # Const::CollectionItem::ItemType
    module ItemType
      TEXT     = 'text'.freeze
      SELECT   = 'select'.freeze
      RADIO    = 'radio'.freeze
      CHECKBOX = 'checkbox'.freeze
      DATE     = 'date'.freeze
    end
  end

  # Const::Controller
  module Controller
    CUSTOMER = 'customers'.freeze
  end

  module View
    # Const::View::Name
    module Name
      HOME_INDEX     = 'ホーム'.freeze
      CUSTOMER_INDEX = '顧客一覧'.freeze
      CUSTOMER_NEW   = '顧客登録'.freeze
      CUSTOMER_SHOW  = '顧客詳細'.freeze
      CUSTOMER_EDIT  = '顧客編集'.freeze
      LINE_NOTIFY    = 'LINE通知'.freeze
      USER_EDIT      = 'ログイン情報'.freeze
    end
  end

  module LineMessage
    # Const::LineMessage::Type
    module Type
      TEXT = 'text'.freeze
    end

    # Const::LineMessage::Code
    module Code
      PUSH                 = 'push'.freeze
      ACCOUNT_USER_MESSAGE = 'account_user_message'.freeze
      NON_ACCOUNT_MESSAGE  = 'non_account_message'.freeze
    end
  end
end
