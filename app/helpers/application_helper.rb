module ApplicationHelper
  def activate_css(controller_name)
    return controller_name == params[:controller] ? ' active' : ''
  end
end
