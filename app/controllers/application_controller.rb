class ApplicationController < ActionController::Base
  before_action :company
  before_action :check_company!

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
    def company
      @company ||= Company.find_by(code: params[:company_code])
    end

    def check_company!
      # 存在しない会社コードの場合
      if params[:company_code].present? && company.blank?
        raise ActiveRecord::RecordNotFound
      end

      # ログインしている場合は所属する会社かどうかをチェック
      if current_user
        # 権限チェック：see: Ability.rb
        authorize! :read, company
      end
    end
end
