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

  private
    def company_params
      params.require(:company).permit(:name)
    end
end
