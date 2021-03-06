class ApplicationController < ActionController::Base
  before_action :check_company!
  before_action :set_locale
  before_action :authenticate_user!, unless: :is_public?
  before_action :store_company
  before_action :store_current_user
  before_action :get_new_user_line_messages, if: :current_user_over_customer?

  # 各アクションで権限をチェック。オプションでモデル依存をfalseに。
  authorize_resource class: false

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  # 権限が無いページへアクセス時の例外処理
  rescue_from CanCan::AccessDenied, with: :render_500

  def render_404
    render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'
  end

  def render_500
    render file: Rails.root.join('public/500.html'), status: 500, layout: false, content_type: 'text/html'
  end

  private
    # レイアウトの指定
    def specification_layout
      if company.blank? || current_user.blank?
        return 'public'
      elsif current_user.customer?
        return 'customer'
      else
        return 'application'
      end
    end

    def company
      @company ||= Company.find_by(code: params[:company_code])
    end

    def check_company!
      # 存在しない会社コードの場合
      if params[:company_code].present? && company.blank?
        raise ActiveRecord::RecordNotFound
      end

      # ログインしている場合は所属する会社かどうかをチェック
      if current_user && company.present?
        # 権限チェック：see: Ability.rb
        authorize! :read, company
      end
    end

    def set_locale
      I18n.locale = extract_locale_from_company_type_for
    end

    def extract_locale_from_company_type_for
      parsed_locale = company.try(:type_for)
      return I18n.default_locale if parsed_locale.blank?
      I18n.available_locales.include?(parsed_locale.to_sym) ? parsed_locale : I18n.default_locale
    end

    def company_code
      company.try(:code)
    end

    def store_company
      RequestStore.store[:company] = company
    end

    def store_current_user
      RequestStore.store[:current_user] = current_user
    end

    def current_user_over_customer?
      company.present? && current_user.try(:over_staff_or_more?)
    end

    def get_new_user_line_messages
      @new_user_line_messages ||= company.line_message_logs.includes(user: :customer).where(
                                   checked: false,
                                  )
    end

    # ログイン無しでもアクセス可能にする制御
    def is_public?
       false
    end

    def store_current_location
      store_location_for(:user, request.url)
    end

    def notify_unread_line_message
      company.try(:line_message_notify_setting).try(:notify_new_line_message, homes_url(company_code: company.code))
    end
end
