module Api
  module V1
    class LinesController < ActionController::Base
      require 'line/bot'

      # CSRF保護を無効
      protect_from_forgery with: :null_session

      IGNORE_REPLY_TOKEN = '00000000000000000000000000000000'.freeze
      QR_CODE_IMAGE_REQUEST = '来店コード'.freeze

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

        message = { type: 'text', text: '' }

        image_message = {
          type: 'image',
          originalContentUrl: '',
          previewImageUrl: '',
        }

        events = client.parse_events_from(body)

        events.each do |event|
          case event
          when Line::Bot::Event::Follow
            save_user(event, company)
            message[:text] = regit_url_message(event, company)
            client.reply_message(event['replyToken'], message) unless event['replyToken'] === IGNORE_REPLY_TOKEN # テスト応答時はメッセージを返信しない
          when Line::Bot::Event::Message
            case event.try(:type)
            when Line::Bot::Event::MessageType::Text
              user = get_user(event, company)

              if user.try(:customer).blank?
                save_user(event, company)
                message[:text] = regit_url_message(event, company)
                user.reload
                client.reply_message(event['replyToken'], message) unless event['replyToken'] === IGNORE_REPLY_TOKEN # テスト応答時はメッセージを返信しない
                break
              end

              if event['message']['text'] == QR_CODE_IMAGE_REQUEST
                today       = Date.today
                year        = today.year.to_s
                month       = today.month.to_s.rjust(2, '0')
                day         = today.day.to_s.rjust(2, '0')
                visited_log = company.visited_logs.where(customer: user.customer, year: year, month: month, day: day).first_or_create
                image_url   = visit_user_qr_code_customers_url(company_code: company.code, visit_token: visited_log.visit_token) + '.png'
                image_message[:originalContentUrl] = image_url
                image_message[:previewImageUrl] = image_url
                client.reply_message(event['replyToken'], image_message)
              else
                save_user_message(event, company)
              end
            end
          end
        end

        head :ok
      end

      private
        def save_user(event, company)
          user = User.find_or_initialize_by(role: :customer, company: company, line_user_id: event['source']['userId'])
          user.save!(validate: false) if user.new_record?
        end

        def save_user_message(event, company)
          user = get_user(event, company)

          lml = user.line_message_logs.new(
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

        def regit_url_message(event, company)
           "【自動応答】登録URL\n#{ new_with_line_customers_url({ company_code: company.code, line_user_id: event['source']['userId'] }) }"
        end

        def get_user(event, company)
          User.find_by(company: company, line_user_id: event['source']['userId'])
        end
    end
  end
end
