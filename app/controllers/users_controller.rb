class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
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

  private
    def set_user
      @user = company.users.find(params[:id])
    end

    def user_params
      wp = params.require(:user).permit(:email, :password)
      wp.delete(:password) if wp[:password].blank?
      wp
    end
end
