class Customer::VisitedLogsController < ApplicationController
  before_action :get_customer
  before_action :get_visited_log, only: [:show, :edit, :update, :delete]

  def new
    today = Date.today
    @visited_log = @customer.visited_logs.new(
      year: today.year.to_s,
      month: today.month.to_s.rjust(2, '0'),
      day: today.day.to_s.rjust(2, '0')
    )
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

  def edit
    @visited_log = company.visited_logs.find(params[:id])
  end

  def update
    @visited_log = company.visited_logs.find(params[:id])
    @visited_log.attributes = visited_log_params

    if @visited_log.save
      redirect_to customer_path(company_code, @customer), notice: "来店履歴の更新が完了しました。"
    else
      render action: :edit
    end
  end

  def destroy
    @visited_log = company.visited_logs.find(params[:id])
    @visited_log.destroy!

    redirect_to customer_path(company_code, @customer), notice: "来店履歴の削除が完了しました。"
  end

  private
    def get_customer
      @customer ||= company.customers.find(params[:customer_id])
    end

    def get_visited_log
      @visited_log ||= get_customer.visited_logs.find(params[:id])
    end

    def visited_log_params
      params.require(:visited_log).permit(:year, :month, :day)
    end
end
