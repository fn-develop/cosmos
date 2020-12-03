class Company::BulkLineMessagesController < ApplicationController
  def index
    @search = CustomerSearch.new({
      company: company,
      current_ability: current_ability,
    }.merge(customer_search_params))

    @customers = @search.search_for_bulk_line_messages
  end

  def create
    massage = params[:message]

    params[:user_ids].each do |user_id|
      @line_message         = LineMessage.new(message: massage + num.to_s, user_id: user_id)
      @line_message.company = company
      @line_message.checked = true

      if @line_message.valid? && company.within_limit_line_message?
        @line_message.send_text_message
      end
    end

    render plain: 'create'
  end

  private
    def customer_search_params
      params.key?(:customer_search) ? params.require(:customer_search).permit(:name, :from_age, :to_age, :gender, :line_registed, :unread_line, :visited_over) : {}
    end

    def bulk_message_params
    end
end
