class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :reset_line_info, :edit, :update, :destroy, :new_line_message, :send_line_message, :new_sms_message, :send_sms_message]
  include LineLinkingController

  VISITED_LOGS_PER = '10'

  def index
    @search = CustomerSearch.new({
      company: company,
      current_ability: current_ability,
      page: params[:page],
    }.merge(customer_search_params))

    @customers = @search.search
  end

  def show
    # 権限チェック：see: Ability.rb
    authorize! :read, @customer
    @visited_logs = @customer.visited_logs.where(enabled: true)
                             .order(year: :desc)
                             .order(month: :desc)
                             .order(day: :desc)
                             .page(params[:page])
                             .per(VISITED_LOGS_PER)
  end

  # xhr
  def reset_line_info
    @user = @customer.user
    @user.reset_line_info
  end

  def new
    @customer = Customer.new
    render :new
  end

  def create
    @customer = company.customers.new(customer_params)

    ApplicationRecord.transaction do
      if @customer.save
        @customer.build_user(company: company, role: :customer).save!(validate: false)
      end
    end

    if @customer.valid?
      redirect_to customer_path(company_code, @customer), notice: "ID:#{ @customer.name }の登録が完了しました。"
    else
      render :new, notice: '入力内容にエラーがあります。'
    end
  end

  def edit
    # 権限チェック：see: Ability.rb
    authorize! :manage, @customer
  end

  def update
    # 権限チェック：see: Ability.rb
    authorize! :manage, @customer
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
      @customer.destroy!
      user.destroy! if user.present?
    end

    redirect_to customers_path(company_code), notice: "顧客:#{ @customer.name }を削除しました。"
  end

  def recent_message_index
    @line_message_logs = company.line_message_logs.where(success_or_failure: true).last(Const::LineMessage::DISPLAY_LIMIT)
  end

  def new_line_message
    # 未閲覧を閲覧済に
    LineMessageLog.where(user_id: @customer.user_id, success_or_failure: true).update_all(checked: true)

    @line_message_logs    = LineMessageLog.where(user_id: @customer.user_id, success_or_failure: true).last(Const::LineMessage::DISPLAY_LIMIT)
    @line_message         = LineMessage.new(user_id:      @customer.user_id)
    @line_message.company = company
  end

  def send_line_message
    if company.within_limit_line_message?
      @line_message         = LineMessage.new(line_message_params)
      @line_message.company = company

      if @line_message.valid?
        @line_message.send_text_message
      end
    else
      flash[:alert] = '送信可能上限に達した為、送信できません。'
    end

    redirect_to new_line_message_customer_path(company_code, @customer)
  end

  def new_sms_message
    @sms_logs = SmsLog.where(customer: @customer).last(Const::SMS::DISPLAY_LIMIT)
  end

  def send_sms_message
    require 'sms-api'

    if company.within_limit_sms_message?
      @client ||= Sms::Client.new { |config| config.company = company }
      res = @client.send_message(@customer.tel_number, params[:message])

      @sms_log = company.sms_logs.new(
        message: params[:message],
        customer: @customer,
        staff: current_user,
        response_code: res.try(:body).to_s,
      )

      @sms_log.save
    else
      flash[:alert] = '送信可能上限に達した為、送信できません。'
    end

    redirect_to new_sms_message_customer_path(company_code, @customer)
  end

  def xhr_get_customers
    @customers = company.customers.where('name LIKE ?', "%#{ params[:name] }%").or(company.customers.where('name_kana LIKE ?', "%#{ params[:name] }%"))
  end

  def xhr_get_base64_message_image
    @customer = company.customers.find(params[:id])
    @line_message_log = @customer.user.line_message_logs.find(params[:message_id])
  end

  def update_introducer
    @customer = company.customers.find(params[:id])
    intoroducer = company.customers.find(params[:introducer_id])

    @customer.introducer = intoroducer
    @customer.save

    redirect_to customer_path(company_code, @customer), notice: "紹介者を変更しました。"
  end

  private
    def set_customer
      @customer = Customer.find(params[:id])
    end

    def customer_params
      params.require(:customer).permit(
        :agreement,
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

    def line_message_params
      params.require(:line_message).permit(:message, :user_id)
    end

    def customer_search_params
      params.key?(:customer_search) ? params.require(:customer_search).permit(:name, :from_age, :to_age, :gender, :line_registed, :unread_line, :visited_over) : {}
    end
end
