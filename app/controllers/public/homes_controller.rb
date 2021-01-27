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
    # ログイン情報の登録が無い場合
    elsif current_user.email.blank?
      redirect_to edit_user_path(company_code, current_user)
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

  # xhr
  def join_calendar_info
    @calendar_joined_user = current_user
      .calendar_joined_users
      .find_by(calendar_id: params[:calendar_id])
  end

  # xhr
  def join_calendar
    @calendar_joined_user = current_user
      .calendar_joined_users
      .find_by(calendar_id: calendar_joined_user_params[:calendar_id])
    if @calendar_joined_user.blank?
      @calendar_joined_user = current_user
        .calendar_joined_users
        .create(calendar_joined_user_params)
    else
      @calendar_joined_user.attributes = calendar_joined_user_params
      @calendar_joined_user.save
    end
  end

  private
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

    def calendar_joined_user_params
      params.require(:calendar_joined_user).permit(:calendar_id, :is_join, :comment)
    end
end
