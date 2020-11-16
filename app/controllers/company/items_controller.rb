class Company::ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def index
    @items = Item.all
  end

  def show
  end

  def new
    @item = Item.new
  end

  def edit
    # 権限チェック：see: Ability.rb
    authorize! :manage, @item
  end

  def create
    @item = company.items.new(item_params)

    if @item.update(item_params)
      redirect_to company_item_path(company_code, @item), notice: "登録完了。"
    else
      flash.now[:alert] = '入力内容にエラーがあります。'
      render :edit
    end
  end

  def update
    # 権限チェック：see: Ability.rb
    authorize! :manage, @item

    if @item.update(item_params)
      redirect_to company_item_path(company_code, @item), notice: "更新完了。"
    else
      flash.now[:alert] = '入力内容にエラーがあります。'
      render :edit
    end
  end

  def destroy
    # 権限チェック：see: Ability.rb
    authorize! :manage, @item

    @item.destroy

    if @item.destroyed?
      redirect_to company_item_path(company_code, @item), notice: "#{@item.code} 削除完了。"
    else
      flash.now[:alert] = '関連情報がある為削除できません。'
      render :edit
    end
  end

  private
    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:code, :name)
    end
end
