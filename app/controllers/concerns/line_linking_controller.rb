# LINE関係
module LineLinkingController
  extend ActiveSupport::Concern

  included do
    layout 'line_regist', only: [:new_with_line, :new_with_line_non_tel_number, :create_with_line]
  end

  def new_with_line
    if params[:line_user_id].blank?
      raise CanCan::AccessDenied
    else
      session[:line_user_id] = params[:line_user_id]
    end

    user = company.users.find_by(line_user_id: session[:line_user_id])
    raise CanCan::AccessDenied if user.blank?

    if user.customer
      render plain: '既にユーザー登録が完了しています。'
    else
      @customer = Customer.new
    end
  end

  def new_with_line_non_tel_number
    if session[:line_user_id].blank?
      raise CanCan::AccessDenied
    end

    user = company.users.find_by(line_user_id: session[:line_user_id])
    raise CanCan::AccessDenied if user.blank?

    if user.customer
      render plain: '既にユーザー登録が完了しています。'
    else
      # 既に入力された電話番号の顧客が存在する場合紐付けて終了
      @customer = customer_with_phone_number
      if @customer.present?
        @customer.user = user
        @customer.save
        session[:line_user_id] = nil
        render plain: 'ユーザー登録が完了しました。'
      else
        @customer = Customer.new(customer_params)
      end
    end
  end

  def create_with_line
    user = company.users.find_by(line_user_id: session[:line_user_id])
    raise CanCan::AccessDenied if user.blank?

    @customer = company.customers.new(customer_params)
    @customer.user = user

    if @customer.save
      session[:line_user_id] = nil
      render plain: '登録が完了しました。'
    else
      render :new_with_line_non_tel_number, layout: 'line_regist', notice: '入力内容にエラーがあります。'
    end
  end

  # xhr
  def reload_notify_area
  end

  def visit_user_qr_code
    @user = company.users.find_by(line_user_id: params[:line_user_id])

    qr_url = complete_visited_customers_url(company_code: company.code, line_user_id: @user.line_user_id)

    base64_image = ApplicationController.helpers.make_base64_qr_code(content: qr_url, size: 8)
    base64_image = base64_image.split(',', 2).last
    send_data ::Base64.decode64(base64_image),
              filename: "qr.png",
              type: 'image/png',
              disposition: 'inline'
  end

  def complete_visited
    @user = company.users.find_by(line_user_id: params[:line_user_id])

    if @user.present?
      render plain: "#{@user.customer.name}さんの来店を受け付けました。"
    else
      render plain: 'ユーザーが見つかりません。'
    end
  end

  private def customer_with_phone_number
    tel_number = "#{customer_params[:tel_number1]}#{customer_params[:tel_number2]}#{customer_params[:tel_number3]}"
    company.customers.find_by(tel_number: tel_number)
  end

  private def is_public?
    ['new_with_line', 'new_with_line_non_tel_number', 'create_with_line', 'visit_user_qr_code'].include?(params[:action])
  end

end
