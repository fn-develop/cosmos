class Company::SettingsController < ApplicationController
  def show
    # 権限チェック：see: Ability.rb
    authorize! :read, @company
  end

  def edit
    # 権限チェック：see: Ability.rb
    authorize! :manage, @company
  end

  def update
    # 権限チェック：see: Ability.rb
    authorize! :manage, @company

    if @company.update(company_params)
      redirect_to company_setting_path(company_code), notice: "更新完了。"
    else
      render :edit, notice: '入力内容にエラーがあります。'
    end
  end

  def edit_notify_setting
    @line_message_notify_setting = company.line_message_notify_setting || company.create_line_message_notify_setting
  end

  def update_notify_setting
    @line_message_notify_setting = company.line_message_notify_setting
    @line_message_notify_setting.attributes = line_message_notify_setting_params

    if @line_message_notify_setting.save
      redirect_to company_setting_path(company_code), notice: "更新が完了しました。"
    else
      render :edit, notice: '入力内容にエラーがあります。'
    end
  end

  def edit_calendar_setting
    render plain: 'edit_calendar_setting'
  end

  def update_calendar_setting
    render plain: 'update_calendar_setting'
  end

  private
    def company_params
      params.require(:company).permit(
        :name,
        :logo,
        :line_qr_code,
        :line_channel_secret,
        :line_channel_token,
      )
    end

    def line_message_notify_setting_params
      params.require(:line_message_notify_setting).permit(
        :notify_enabled,
        :norify_time_from,
        :norify_time_to,
        :notify_cycle,
        :notify_target,
        :auto_message_on_time,
        :auto_message_off_time,
      )
    end

    def calendar_setting_params
      params.require(:calendar_setting).permit()
    end
end
