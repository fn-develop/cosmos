module Const
  module CollectionItem
    module ItemType
      TEXT     = 'text'.freeze
      SELECT   = 'select'.freeze
      RADIO    = 'radio'.freeze
      CHECKBOX = 'checkbox'.freeze
      DATE     = 'date'.freeze
    end
  end

  module Controller
    CUSTOMER = 'customers'.freeze
  end

  module View
    module Name
      HOME_INDEX     = 'ホーム'.freeze
      CUSTOMER_INDEX = '顧客一覧'.freeze
      CUSTOMER_NEW   = '顧客登録'.freeze
      CUSTOMER_SHOW  = '顧客詳細'.freeze
      CUSTOMER_EDIT  = '顧客編集'.freeze
      LINE_NOTIFY    = 'LINE通知'.freeze
    end
  end

  module LineMessage
    module Type
      TEXT = 'text'.freeze
    end
  end
end
