module Const
  # Const::Item
  module Item
    # Const::Item::Code
    module Code
      CALENDAR = 'calendar'.freeze
    end

    # Const::Item::SubCode
    module SubCode
      TEXT_INPUT    = 'text_input'.freeze
      TEXT_AREA     = 'text_area'.freeze
      SELECT_OPTION = 'select_option'.freeze
      RADIO         = 'radio'.freeze
      CHECKBOX      = 'checkbox'.freeze
      DISP          = 'disp'.freeze
    end
  end

  # Const::CollectionItem
  module CollectionItem
    ITEM_TYPE = [
      Item::SubCode::SELECT_OPTION,
      Item::SubCode::RADIO,
      Item::SubCode::CHECKBOX,
    ].freeze
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
