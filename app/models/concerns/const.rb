module Const
  # Const::Item
  module Item
    # Const::Item::Code
    module Code
      CALENDAR = 'calendar'.freeze
    end

    # Const::Item::SubCode
    module SubCode
      INPUT = 'input'.freeze
      DISP  = 'disp'.freeze
    end
  end

  module CollectionItem
    # Const::CollectionItem::ItemType
    module ItemType
      TEXT          = 'text'.freeze
      SELECT_OPTION = 'select_option'.freeze
      RADIO         = 'radio'.freeze
      CHECKBOX      = 'checkbox'.freeze
      DATE          = 'date'.freeze
    end
  end

  # Const::Controller
  module Controller
    CUSTOMER = 'customers'.freeze
  end

  # Const::LineMessage
  module LineMessage
    # Const::LineMessage::Type
    module Type
      TEXT  = 'text'.freeze
      IMAGE = 'image'.freeze
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
