class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :reset_line_info]
  layout :specification_layout

  def show
    # 権限チェック：see: Ability.rb
    authorize! :manage, @user
  end

  def new
    @user = User.new
  end

  def edit
    # 権限チェック：see: Ability.rb
    authorize! :manage, @user
    @user.build_customer if @user.customer.blank?
  end

  def update
    # 権限チェック：see: Ability.rb
    authorize! :manage, @user
    @user.attributes = user_params

    if @user.save
      if @user.id == current_user.id
        bypass_sign_in(@user)
      end
      redirect_to user_url(company_code, @user), notice: '更新完了'
    else
      render :edit
    end
  end

  # xhr
  def reset_line_info
    @user.reset_line_info
  end

  private
    def set_user
      @user = company.users.find(params[:id])
    end

    def user_params
      wp = params.require(:user).permit(
        :email,
        :password,
        customer_attributes: [
          :company_id,
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
        ],
      )
      wp.delete(:password) if wp[:password].blank?
      wp
    end
end
