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
        client = LineUser::client
        unless client.validate_signature(body, signature) || company.blank?
          error 400 do 'Bad Request' end
        end

        message = {type: 'text', text: '不明なアクセスです。'}

        events = client.parse_events_from(body)

        events.each do |event|
          case event
          when Line::Bot::Event::Follow
            save_line_user(event, company)
            message[:text] = "下記URLにアクセスしユーザー登録を完了してください。\n（#{regist_with_line_customers_path(event['replyToken'])}）"
          when Line::Bot::Event::Message
            case event.try(:type)
            when Line::Bot::Event::MessageType::Text
              if event.message['text'] === 'XXX'
                save_line_user(event, company)
                message[:text] = "XXX\n（#{regist_with_line_customers_path(event['replyToken'])}）"
              else
                message[:text] = 'XXX'
              end
            end
          end

          client.reply_message(event['replyToken'], message) unless event['replyToken'] === IGNORE_REPLY_TOKEN # テスト応答時はメッセージを返信しない
        end

        head :ok
      end

    private
      def save_line_user(event, company)
        line_user              = LineUser.find_or_initialize_by(line_user_id: event['source']['userId'])
        line_user.company      = company
        line_user.request_json = params.to_json
        line_user.reply_token  = event['replyToken']
        line_user.save
        return line_user
      end

    end
  end
end
