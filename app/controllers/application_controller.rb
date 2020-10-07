class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # 各アクションで権限をチェック。オプションでモデル依存をfalseに。
  authorize_resource class: false

  # 権限が無いページへアクセス時の例外処理
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to '/500.html'
  end
end
