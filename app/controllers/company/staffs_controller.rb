class Company::StaffsController < ApplicationController
  before_action :set_staff, only: [:show, :edit, :update, :destroy]

  PER = 20

  def index
    @staffs = company.users.where(role: :staff).page(params[:page]).per(PER)
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = company.users.new
    @user.attributes = user_params
    @user.role = :staff

    if @user.save
      redirect_to company_staff_path(company_code, @user), notice: '登録完了'
    else
      render :new
    end
  end

  def edit
    # 権限チェック：see: Ability.rb
    authorize! :update, @user
  end

  def update
    # 権限チェック：see: Ability.rb
    authorize! :update, @user
    @user.attributes = user_params

    if @user.save
      redirect_to company_staff_path(company_code, @user), notice: '更新完了'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy!
    redirect_to company_staffs_path, notice: "ID:#{ @user.id }のスタッフを削除しました。"
  end

  private
    def set_staff
      @user = company.users.find(params[:id])
    end

    def user_params
      wp = params.require(:user).permit(:email, :password)
      wp.delete(:password) if wp[:password].blank?
      wp
    end
end
