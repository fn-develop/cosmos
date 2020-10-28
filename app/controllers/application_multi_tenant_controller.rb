class ApplicationMultiTenantController < ApplicationController
  before_action :authenticate_user!, unless: :is_public?
  # 各アクションで権限をチェック。オプションでモデル依存をfalseに。
  authorize_resource class: false

  private
    # ログイン無しでもアクセス可能にする制御
    def is_public?
       false
    end
end
