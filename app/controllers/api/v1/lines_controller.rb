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
        client = LineMessage.new.client
        unless client.validate_signature(body, signature) || company.blank?
          error 400 do 'Bad Request' end
        end

        message = { type: 'text', text: '不明なアクセスです。' }

        events = client.parse_events_from(body)

        events.each do |event|
          case event
          when Line::Bot::Event::Follow
            save_line_user(event, company)
            message[:text] = "【自動応答メッセージ】下記URLにアクセスしユーザー登録を完了してください。\n（#{ new_with_line_customers_url({ company_code: company.code, reply_token: event['replyToken'] }) }）"
          when Line::Bot::Event::Message
            case event.try(:type)
            when Line::Bot::Event::MessageType::Text
              save_line_user(event, company)
              save_sender_message(event, company)
              message[:text] = "【自動応答メッセージ】再登録は下記URLで行えます。\n（#{ new_with_line_customers_url({ company_code: company.code, reply_token: event['replyToken'] }) }）"
            end
          end

          client.reply_message(event['replyToken'], message) unless event['replyToken'] === IGNORE_REPLY_TOKEN # テスト応答時はメッセージを返信しない
        end

        head :ok
      end

      private
        def save_line_user(event, company)
          line_user              = LineUser.find_or_initialize_by(company: company, line_user_id: event['source']['userId'])
          line_user.request_json = params.to_json
          line_user.reply_token  = event['replyToken']
          line_user.save
          return line_user
        end

        def save_sender_message(event, company)
          line_user = LineUser.find_or_initialize_by(company: company, line_user_id: event['source']['userId'])
          lml = LineMessageLog.build(
            company:      company,
            code:         Const::LineMessage::Code::ACCOUNT_USER_MESSAGE,
            line_user_id: event['source']['userId'],
            message:      event['message']['text'],
          )
          if line_user.user
            lml.user = line_user.user
            lml.code = Const::LineMessage::Code::ACCOUNT_USER_MESSAGE
          else
            lml.code = Const::LineMessage::Code::NON_ACCOUNT_MESSAGE
          end

          lml.save
        end
    end
  end
end
