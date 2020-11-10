module Api
  module V1
    class LinesController < ActionController::Base
      require 'line/bot'

      # CSRF保護を無効
      protect_from_forgery with: :null_session

      IGNORE_REPLY_TOKEN = '00000000000000000000000000000000'

      def show
        head :ok
      end

      def callback
        company = Company.find_by(code: params[:company_code])

        body = request.body.read
        signature = request.env['HTTP_X_LINE_SIGNATURE']
        client = LineMessage.new(company: company).client
        unless client.validate_signature(body, signature) || company.blank?
          error 400 do 'Bad Request' end
        end

        message = { type: 'text', text: '不明なアクセスです。' }

        events = client.parse_events_from(body)

        events.each do |event|
          case event
          when Line::Bot::Event::Follow
            save_user(event, company)
            message[:text] = "【自動応答メッセージ】下記URLにアクセスしユーザー登録を完了してください。\n（#{ new_with_line_customers_url({ company_code: company.code, line_user_id: event['source']['userId'] }) }）"
            client.reply_message(event['replyToken'], message) unless event['replyToken'] === IGNORE_REPLY_TOKEN # テスト応答時はメッセージを返信しない
          when Line::Bot::Event::Message
            case event.try(:type)
            when Line::Bot::Event::MessageType::Text
              save_user_message(event, company)
            end
          end
        end

        head :ok
      end

      private
        def save_user(event, company)
          user = User.find_or_initialize_by(company: company, line_user_id: event['source']['userId'])
          user.save if user.new_record?
          user
        end

        def save_user_message(event, company)
          user = User.find_by(company: company, line_user_id: event['source']['userId'])

          lml = user.line_message_log.new(
            company:      company,
            message_id:   event['message']['id'],
            line_user_id: event['source']['userId'],
            message:      event['message']['text'],
          )
          if user.customer.present?
            lml.code = Const::LineMessage::Code::ACCOUNT_USER_MESSAGE
          else
            lml.code = Const::LineMessage::Code::NON_ACCOUNT_MESSAGE
          end

          lml.save
        end
    end
  end
end
