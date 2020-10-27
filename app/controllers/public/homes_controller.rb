class Public::HomesController < ApplicationController
  def index
    if company.blank?
      render action: :index_public, layout: 'public'
      return
    end

    # 未ログインユーザーの場合
    if current_user.blank?
      render action: :index_company, layout: 'public'
    # 管理者、オーナー、店舗スタッフ
    elsif current_user.admin? || current_user.owner? || current_user.staff?
      render action: :index_staff, layout: 'application'
    # 顧客ユーザーの場合
    else
      render action: :index_customer, layout: 'public'
    end
  end
end
