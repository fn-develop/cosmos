class ApplicationMultiTenantController < ApplicationController
  before_action :authenticate_user!, :check_company_user!, unless: :is_public?
  # 各アクションで権限をチェック。オプションでモデル依存をfalseに。
  authorize_resource class: false

  private
    def company
      @company ||= Company.find_by(code: params[:company_code])
    end

    def check_company_user!
      raise CanCan::AccessDenied if company.blank?
      company.users.find(current_user.id)
    end

    def is_public?
       false
    end
end
