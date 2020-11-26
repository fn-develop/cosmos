module ApplicationHelper
  require 'rqrcode'
  require 'chunky_png'

  def activate_css(controller_name)
    return controller_name == params[:controller] ? ' active' : ''
  end

  # テキストエリア等で入力された改行コードをbrに変換する
  def br(str)
    html_escape(str).gsub(/\r\n|\r|\n/, '<br />').html_safe
  end

  def make_png_qr_code(content:, size: 3, level: :m, height: 200, width: 200)
    # size # 1..40
    # level # l, m, q, h
    qr = RQRCode::QRCode.new(content, size: size, level: level)
    qr.as_png.resize(height, width)
  end

  def make_base64_qr_code(content)
    png = make_png_qr_code(content)
    png.to_data_url
  end
end
