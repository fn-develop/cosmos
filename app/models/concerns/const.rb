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

  # Const::View
  module View
    # Const::View::Name
    module Name
      HOME_INDEX           = 'ホーム'.freeze
      CUSTOMER_INDEX       = '顧客一覧'.freeze
      CUSTOMER_NEW         = '顧客登録'.freeze
      CUSTOMER_SHOW        = '顧客情報'.freeze
      CUSTOMER_EDIT        = '顧客編集'.freeze
      LINE_NOTIFY          = 'LINE通知'.freeze
      USER_SHOW            = 'アカウント'.freeze
      USER_EDIT            = 'アカウント'.freeze
      COMPANY_SETTING_SHOW = '店舗情報'.freeze
      COMPANY_SETTING_EDIT = '店舗編集'.freeze
      COMPANY_ITEMS_INDEX  = 'システム項目一覧'.freeze
      COMPANY_ITEMS_NEW    = 'システム項目登録'.freeze
      COMPANY_ITEMS_SHOW   = 'システム項目情報'.freeze
      COMPANY_ITEMS_EDIT   = 'システム項目編集'.freeze
      VISITED_LOG          = '来店履歴'.freeze
    end
  end

  # Const::LineMessage
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

    DISPLAY_LIMIT = 100.freeze
  end
end
