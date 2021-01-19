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
    # 管理者、オーナー、スタッフ
    elsif current_user.system_admin? || current_user.owner? || current_user.staff?
      render action: :index_for_system
    # 顧客ユーザーの場合
    else
      calendar_events if company.is_calendar_feature?
      render action: :index_for_customer_user
    end
  end

  def calendar
    if company.blank?
      render action: :index_for_public
      return
    end

    calendar_events
  end

  private
    # レイアウトの指定
    def specification_layout
      if company.blank? || current_user.blank?
        return 'public'
      elsif current_user.customer?
        return 'customer'
      else
        return 'application'
      end
    end

    def is_public?
       true
    end

    def calendar_events
      @calendar_events ||= company.calendars.where(
          'start > ?', Date.today - 3.month
        ).where(
          event_type: company.calendar_open_event_types.to_a
        )
    end
end
