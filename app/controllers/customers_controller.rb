class CustomersController < ApplicationMultiTenantController
  before_action :set_customer, only: [:show, :new_line_message, :send_line_message]
  before_action :company

  def index
    @customers = company.customer_users
  end

  def show
  end

  def new
    session[:reply_token] = params[:reply_token]
    line_user = company.line_users.find_by(reply_token: params[:reply_token])

    CanCan::AccessDenied if line_user.blank?

    if line_user.user
      render plain: '既にユーザー登録が完了しています。'
    else
      @customer = Customer.new
    end
  end

  def create
    @customer = Customer.new(customer_params)

    ApplicationRecord.transaction do
      if @customer.save
        @customer.create_user!(companies: [company])
        if session[:reply_token].present?
          company.line_users.find_by(reply_token: session[:reply_token]).update_attributes!(user: @customer.user)
        end
      end
    end

    if @customer.valid?
      session[:company_code] = session[:reply_token] = nil
      redirect_to customer_path(@customer, { company_code: company.code }), notice: "登録が完了しました。"
    else
      render :new
    end
  end

  def new_line_message
    @line_message = LineMessage.new(user_id: @customer.user_id)
  end

  def send_line_message
    @line_message = LineMessage.new(line_message_params)
    if @line_message.valid?
      @line_message.send_text_message
    end
    render 'new_line_message'
  end

  private
    def set_customer
      @customer = Customer.find(params[:id])
    end

    def customer_params
      params.require(:customer).permit(:name, :name_kana, :gender, :tel_number, :birthday, :postal_code, :prefecture, :city, :address1, :address2)
    end

    def is_public?
      true
    end

    def line_message_params
      params.require(:line_message).permit(:message, :user_id)
    end
end
