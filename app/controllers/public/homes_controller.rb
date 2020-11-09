class Public::HomesController < ApplicationController
  layout :specification_layout

  def index
    if company.blank?
      render action: :index_for_public
      return
    end

    # 未ログインユーザーの場合
    if current_user.blank?
      render action: :index_for_tenant_promotion
    # 管理者、オーナー、店舗スタッフ
    elsif current_user.admin? || current_user.owner? || current_user.staff?
      render action: :index_for_system
    # 顧客ユーザーの場合
    else
      render action: :index_for_customer_user
    end
  end

  private
    # レイアウトの指定
    def specification_layout
      if company.blank? || current_user.blank? || (!current_user.admin? && current_user.customer?)
        return 'public'
      else
        return 'application'
      end
    end

    def is_public?
       true
    end
end
