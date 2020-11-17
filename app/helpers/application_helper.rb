module ApplicationHelper
  def activate_css(controller_name)
    return controller_name == params[:controller] ? ' active' : ''
  end

  # テキストエリア等で入力された改行コードをbrに変換する
  def br(str)
    html_escape(str).gsub(/\r\n|\r|\n/, '<br />').html_safe
  end
end
