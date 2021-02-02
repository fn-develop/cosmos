module Api
  module V1
    class LinesController < ActionController::Base
      require 'line/bot'

      # CSRF保護を無効
      protect_from_forgery with: :null_session

      before_action :validate_signature

      IGNORE_REPLY_TOKEN = '00000000000000000000000000000000'.freeze
      QR_CODE_IMAGE_REQUEST = '>QRコード'.freeze
      GET_INVITE_CODE_MESSAGE = '>紹介コード'.freeze
      FLEX＿MENU_MESSAGE = '>メニュー'.freeze
      ON_TIME_MESSAGE  = "【自動応答メッセージ】\nメッセージを承りました。\n店舗スタッフへ転送中の為、返信はしばらくお待ちください。".freeze
      OFF_TIME_MESSAGE = "【自動応答メッセージ】\n営業時間外の為、返信はしばらくお待ちください。".freeze

      def show
        head :ok
      end

      def callback
        events = client.parse_events_from(request.body.read)

        events.each do |event|
          case event
          when Line::Bot::Event::Follow
            follow(event)
          when Line::Bot::Event::Message
            case event.try(:type)
            when Line::Bot::Event::MessageType::Text
              message_text(event)
            when Line::Bot::Event::MessageType::Image
              message_image(event)
            end
          end
        end

        head :ok
      end

      def validate_signature
        body = request.body.read
        signature = request.env['HTTP_X_LINE_SIGNATURE']
        if !client.validate_signature(body, signature) || company.blank?
          head 400 do 'Bad Request' end
        end
      end

      private
        def follow(event)
          save_user(event)
          message = { type: Const::LineMessage::Type::TEXT, text: '' }
          message[:text] = regit_url_message(event)
          client.reply_message(event['replyToken'], message) unless event['replyToken'] === IGNORE_REPLY_TOKEN # テスト応答時はメッセージを返信しない
        end

        def message_text(event)
          user = get_user(event)

          if user.try(:customer).blank?
            follow(event)
            return
          end

          image_message = {
            type: Const::LineMessage::Type::IMAGE,
            originalContentUrl: '',
            previewImageUrl: '',
          }

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
          elsif event['message']['text'] == FLEX＿MENU_MESSAGE
            flex_menu_message = LineFlexMenu::site_menu(
              line_in_url({
                company_code: company.code,
                line_user_id: event['source']['userId']
              })
            )
            client.push_message(event['source']['userId'], flex_menu_message, headers: { 'Content-Type' => 'application/json' })
          elsif company.is_inviting_feature? && event['message']['text'] == GET_INVITE_CODE_MESSAGE
            client.reply_message(event['replyToken'], { type: Const::LineMessage::Type::TEXT, text: user.customer.invite_code })
          else
            save_text_message(event)
            setting = company.line_message_notify_setting
            if setting.present? && !setting.active_time?(DateTime.now)
              auto_message = setting.auto_message_off_time.present? ? setting.auto_message_off_time : OFF_TIME_MESSAGE
              client.reply_message(event['replyToken'], { type: Const::LineMessage::Type::TEXT, text: auto_message })
            else
              auto_message = setting.auto_message_on_time.present? ? setting.auto_message_on_time : ON_TIME_MESSAGE
              client.reply_message(event['replyToken'], { type: Const::LineMessage::Type::TEXT, text: auto_message })
            end
          end
        end

        def message_image(event)
          user = get_user(event)

          if user.try(:customer).blank?
            follow(event)
            return
          else
            save_image_message(event)
          end
        end

        def client
          LineMessage.new(company: company).client
        end

        def company
          @company ||= Company.find_by(code: params[:company_code])
        end

        def save_user(event)
          user = User.find_or_initialize_by(role: :customer, company: company, line_user_id: event['source']['userId'])
          user.save!(validate: false) if user.new_record?
          user.reset_line_info
        end

        def save_text_message(event)
          user = get_user(event)

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
          notify_unread_line_message

          lml
        end

        def save_image_message(event)
          image_response = client.get_message_content(event['message']['id'])
          tf = File.open("/tmp/#{SecureRandom.uuid}.jpg", "w+b")
          tf.write(image_response.body)
          user = get_user(event)

          lml = user.line_message_logs.new(
            company:          company,
            message_id:       event['message']['id'],
            line_user_id:     event['source']['userId'],
            message_type:     Const::LineMessage::Type::IMAGE,
            image: tf,
          )

          if user.customer.present?
            lml.code = Const::LineMessage::Code::ACCOUNT_USER_MESSAGE
          else
            lml.code = Const::LineMessage::Code::NON_ACCOUNT_MESSAGE
          end

          lml.save
          lml
        end

        def regit_url_message(event)
           "【自動応答】登録URL\n#{ new_with_line_customers_url({ company_code: company.code, line_user_id: event['source']['userId'] }) }"
        end

        def get_user(event)
          @user ||= User.find_by(company: company, line_user_id: event['source']['userId'])
        end

        def notify_unread_line_message
          company.try(:line_message_notify_setting).try(:notify_new_line_message, homes_url(company_code: company.code))
        end
    end
  end
end
