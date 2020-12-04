class Company::BulkLineMessagesController < ApplicationController
  def index
    @search = CustomerSearch.new({
      company: company,
      current_ability: current_ability,
    }.merge(customer_search_params))

    @customers = @search.search_for_bulk_line_messages
    @line_message_bulk_logs = company.line_message_bulk_logs.order(id: :desc).last(100)
  end

  def create
    message = params[:message]

    enabled_user_ids = []
    disabled_user_ids = []

    params[:user_ids].each do |user_id|
      break unless company.within_limit_line_message?

      @line_message         = LineMessage.new(message: message, user_id: user_id)
      @line_message.company = company

      if @line_message.valid?
        if @line_message.send_text_message
          enabled_user_ids.push user_id
        else
          disabled_user_ids.push user_id
        end
      end
    end

    company.line_message_bulk_logs.create(
      message: message,
      enabled_user_ids: enabled_user_ids,
      disabled_user_ids: disabled_user_ids,
    )

    redirect_to company_bulk_line_messages_path, notice: "送信が完了しました。"
  end

  def show
    @line_message_bulk_log = company.line_message_bulk_logs.find(params[:id])
  end

  def destroy
    @line_message_bulk_log = company.line_message_bulk_logs.find(params[:id])
    @line_message_bulk_log.destroy!

    redirect_to company_bulk_line_messages_path, notice: "ID:#{@line_message_bulk_log.id} 一括送信履歴の削除が完了しました。"
  end

  private
    def customer_search_params
      params.key?(:customer_search) ? params.require(:customer_search).permit(:name, :from_age, :to_age, :gender, :line_registed, :unread_line, :visited_over) : {}
    end

    def bulk_message_params
    end
end
