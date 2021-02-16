class ChatLogsController < ApplicationController
  def index
    @chat_logs = company.chat_logs.last(Const::LineMessage::DISPLAY_LIMIT)
  end

  # xhr
  def create
    @chat_log = company.chat_logs.new
    @chat_log.attributes = chat_log_params
    @chat_log.user = current_user

    @chat_log.save
  end

  private
    def chat_log_params
      params.require(:chat_log).permit(
        :message,
      )
    end
end
