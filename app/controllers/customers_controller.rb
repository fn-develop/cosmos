class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy, :new_line_message, :send_line_message]

  def index
    @customers = company.customers.includes(user: [:line_message_logs])
  end

  def show
  end

  def new_with_line
    raise CanCan::AccessDenied if params[:line_user_id].blank?
    user = company.users.find_by(line_user_id: params[:line_user_id])
    raise CanCan::AccessDenied if user.blank?

    if user.customer
      render plain: '既にユーザー登録が完了しています。'
    else
      @customer = Customer.new
      render layout: 'line_regist'
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
      render :new_with_line, layout: 'line_regist', notice: '入力内容にエラーがあります。'
    end
  end

  def new
    @customer = Customer.new
    render :new
  end

  def create
    @customer         = Customer.new(customer_params)
    @customer.company = company

    ApplicationRecord.transaction do
      if @customer.save
        @customer.create_user!(company: company)
      end
    end

    if @customer.valid?
      redirect_to customer_path(company_code, @customer), notice: "ID:#{ @customer.name }の登録が完了しました。"
    else
      render :new, notice: '入力内容にエラーがあります。'
    end
  end

  def edit
  end

  def update
    @customer.attributes = customer_params

    if @customer.save
      redirect_to customer_path(company_code, @customer), notice: "ID:#{ @customer.id }の更新が完了しました。"
    else
      render :edit, notice: '入力内容にエラーがあります。'
    end
  end

  def destroy
    ApplicationRecord.transaction do
      user = @customer.user
      user.destroy!
    end

    redirect_to customers_path(company_code), notice: "顧客:#{ @customer.name }を削除しました。"
  end

  def new_line_message
    # 未閲覧を閲覧済に
    LineMessageLog.where(user_id: @customer.user_id, success_or_failure: true).update_all(checked: true)

    @line_message_logs    = LineMessageLog.where(user_id: @customer.user_id, success_or_failure: true)
    @line_message         = LineMessage.new(user_id:      @customer.user_id)
    @line_message.company = company
  end

  def send_line_message
    @line_message         = LineMessage.new(line_message_params)
    @line_message.company = company

    if @line_message.valid?
      @line_message.send_text_message
    end

    redirect_to new_line_message_customer_path(company_code, @customer)
  end

  private
    def set_customer
      @customer = Customer.find(params[:id])
    end

    def customer_params
      params.require(:customer).permit(
        :name,
        :name_kana,
        :gender,
        :tel_number1,
        :tel_number2,
        :tel_number3,
        :birthday,
        :postal_code1,
        :postal_code2,
        :prefecture,
        :city,
        :address1,
        :address2,
      )
    end

    def is_public?
      ['new_with_line', 'create_with_line'].include?(params[:action])
    end

    def line_message_params
      params.require(:line_message).permit(:message, :user_id)
    end
end
