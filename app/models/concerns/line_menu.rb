class LineMenu
  def self.flex_menu(line_login_url)
    self.bubble_box_menu([
      ['サイトメニュー', line_login_url],
    ])
  end

  def self.bubble_box_menu(urls)
    {
      type: Const::LineMessage::Type::FLEX,
      altText: 'Flex Message',
      contents: {
        type: "bubble",
        body: {
          type: "box",
          layout: "vertical",
          spacing: "md",
          contents: urls.map { |label, url|  self.button_contents(label, url) },
        }
      }
    }
  end

  def self.button_contents(label, url)
    {
      type: "button",
      action: {
        type: "uri",
        label: label,
        uri: url,
      }
    }
  end

  module MenuType
    ONE_BUTTON = 'one_button'
  end

  def self.apply_richmenu(menu_type, client, user, image)
  end

  def self.one_button_insite_rich_menu_has(uri)
    {
      size: {
        width: 800,
        height: 270
      },
      selected: true,
      name: 'Site Login',
      chatBarText: 'Tap to open',
      areas: [
        {
          bounds: {
            x: 0,
            y: 0,
            width: 800,
            height: 270
          },
          action: {
            type: 'uri',
            uri: uri
          }
        }
      ]
    }
  end
end
