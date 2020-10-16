class Public::HomesController < ApplicationController
  before_action :check_company!
  layout false

  def index
  end

  private
    def check_company!
      @company = Company.find_by(code: params[:company_code])
      if params[:company_code].present? && @company.blank?
        raise ActiveRecord::RecordNotFound
      end
    end
end
