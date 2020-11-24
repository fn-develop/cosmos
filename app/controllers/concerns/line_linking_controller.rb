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


  private def customer_with_phone_number
    tel_number = "#{customer_params[:tel_number1]}#{customer_params[:tel_number2]}#{customer_params[:tel_number3]}"
    company.customers.find_by(tel_number: tel_number)
  end

  private def is_public?
    ['new_with_line', 'new_with_line_non_tel_number', 'create_with_line'].include?(params[:action])
  end

end
