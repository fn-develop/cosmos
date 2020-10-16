class Public::HomesController < ApplicationController
  layout false
  def index
    @company = Company.find_by(code: params[:company_code])
  end
end
