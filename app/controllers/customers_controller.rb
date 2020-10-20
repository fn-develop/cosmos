class CustomersController < ApplicationMultiTenantController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  # GET /customers
  # GET /customers.json
  def index
    @customers = company.customer_users
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    company_code = session[:company_code] = params[:company_code]
    reply_token  = session[:reply_token]  = params[:reply_token]
    line_user    = company.line_users.find_by(reply_token: reply_token)

    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)

    ApplicationRecord.transaction do
      if @customer.save
        @customer.create_user!(companies: [company])
      end
    end

    if @customer.valid?
      redirect_to customer_path(@customer, { company_code: session[:company_code] }), notice: "登録が完了しました。"
    else
      render :new
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to @customer, notice: 'Customer was successfully updated.' }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url, notice: 'Customer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_params
      params.require(:customer).permit(:name, :name_kana, :gender, :tel_number, :birthday, :postal_code, :prefecture, :city, :address1, :address2)
    end

    def is_public?
      true
    end
end
