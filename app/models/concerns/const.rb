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
      INDEX       = '顧客一覧'.freeze
      NEW         = '顧客情報登録'.freeze
      SHOW        = '顧客情報参照'.freeze
      LINE_NOTIFY = 'LINE通知'.freeze
    end
  end

  module LineMessage
    module Type
      TEXT = 'text'.freeze
    end
  end
end
