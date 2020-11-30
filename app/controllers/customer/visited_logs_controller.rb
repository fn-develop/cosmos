class Customer::VisitedLogsController < ApplicationController
  before_action :get_customer

  def new
    @visited_log = @customer.visited_logs.new
  end

  private
    def get_customer
      @customer ||= company.customers.find(params[:customer_id])
    end
end
