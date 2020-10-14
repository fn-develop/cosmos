class ApplicationController < ActionController::Base
  # 権限が無いページへアクセス時の例外処理
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to '/500.html'
  end
end
