class Company::SmsLogsController < ApplicationController
  before_action :set_sms_log, only: [:show, :edit, :update, :destroy]

  SMS_LOGS_PER = '100'

  def index
    referer_path = Rails.application.routes.recognize_path(request.referer)
    if referer_path[:controller] == 'customers' && referer_path[:action] == 'index'
      session[:customer_search_params] = customer_search_params
    end

    @search = CustomerSearch.new({
      company: company,
      current_ability: current_ability,
    }.merge(session[:customer_search_params] || {}))

    @customers = @search.search_for_sms
    @sms_logs = company.sms_logs
                       .order(created_at: :desc)
                       .page(params[:page])
                       .per(SMS_LOGS_PER)
  end

  def create
    require 'sms-api'
    @client ||= Sms::Client.new { |config| config.company = company }
    target_customers = company.customers.where(id: params[:customer_ids])

    if target_customers.blank?
      flash[:message] = params[:message]
      flash[:alert] = '送信対象を選択してください。'
    else
      target_customers.each do |customer|
        unless company.within_limit_sms_message?
          flash[:alert] = '送信上限を超えました。'
          break
        end
        res = @client.send_message(customer.tel_number, params[:message])
        sms_log = company.sms_logs.new(
          message: params[:message],
          customer: customer,
          staff: current_user,
          response_code: res.try(:body).to_s,
        )
        sms_log.save
        company.reload
      end
    end

    redirect_to company_sms_logs_path(company_code)
  end

  private
    def customer_search_params
      params.key?(:customer_search) ? params.require(:customer_search).permit(:name, :from_age, :to_age, :gender, :line_registed, :unread_line, :visited_over) : {}
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_sms_log
      @sms_log = SmsLog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sms_log_params
      params.fetch(:sms_log, {})
    end
end
