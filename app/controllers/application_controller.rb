class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  # 権限が無いページへアクセス時の例外処理
  rescue_from CanCan::AccessDenied, with: :render_500

  def render_404
    render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'
  end

  def render_500
    render file: Rails.root.join('public/500.html'), status: 500, layout: false, content_type: 'text/html'
  end
end
