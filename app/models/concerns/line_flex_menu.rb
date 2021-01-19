class LineFlexMenu
  def self.site_menu(line_login_url)
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
end
