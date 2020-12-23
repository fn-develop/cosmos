class Company::ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def index
    @items = company.items
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
    if @item.save
      redirect_to company_item_path(company_code, @item), notice: "登録完了。"
    else
      flash.now[:alert] = '入力内容にエラーがあります。'
      render :new
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
      redirect_to company_items_path, notice: "ID:#{@item.id} の削除完了。"
    else
      flash.now[:alert] = '関連情報がある為削除できません。'
      render :edit
    end
  end

  def calendar_item
    render plain: 'calendar_item'
  end

  private
    def set_item
      @item ||= company.items.find(params[:id])
    end

    def item_params
      params.require(:item).permit(
        :code,
        :sub_code,
        :name,
        collection_items_attributes: [
          :key,
          :value,
          :sort_order,
          :enabled,
          :'_destroy',
          :id,
        ],
      )
    end
end
