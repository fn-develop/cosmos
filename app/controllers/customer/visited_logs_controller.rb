class Customer::VisitedLogsController < ApplicationController
  before_action :get_customer
  before_action :get_visited_log, only: [:show, :edit, :update, :delete]

  def new
    @visited_log = @customer.visited_logs.new
  end

  def create
    @visited_log = @customer.visited_logs.new(visited_log_params)
    @visited_log.company = company
    @visited_log.enabled = true

    if @visited_log.save
      redirect_to customer_path(company_code, @customer), notice: "#{ @visited_log.visited_day }の登録が完了しました。"
    else
      render :new, notice: '入力内容にエラーがあります。'
    end
  end

  private
    def get_customer
      @customer ||= company.customers.find(params[:customer_id])
    end

    def get_visited_log
      @visited_log ||=get_customer.visited_logs.find(params[:id])
    end

    def visited_log_params
      params.require(:visited_log).permit(:year, :month, :day)
    end
end
