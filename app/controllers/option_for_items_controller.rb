class OptionForItemsController < ApplicationController
  before_action :set_option_for_item, only: [:show, :edit, :update, :destroy]

  # GET /option_for_items
  # GET /option_for_items.json
  def index
    @option_for_items = OptionForItem.all
  end

  # GET /option_for_items/1
  # GET /option_for_items/1.json
  def show
  end

  # GET /option_for_items/new
  def new
    @option_for_item = OptionForItem.new
  end

  # GET /option_for_items/1/edit
  def edit
  end

  # POST /option_for_items
  # POST /option_for_items.json
  def create
    @option_for_item = OptionForItem.new(option_for_item_params)

    respond_to do |format|
      if @option_for_item.save
        format.html { redirect_to @option_for_item, notice: 'Option for item was successfully created.' }
        format.json { render :show, status: :created, location: @option_for_item }
      else
        format.html { render :new }
        format.json { render json: @option_for_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /option_for_items/1
  # PATCH/PUT /option_for_items/1.json
  def update
    respond_to do |format|
      if @option_for_item.update(option_for_item_params)
        format.html { redirect_to @option_for_item, notice: 'Option for item was successfully updated.' }
        format.json { render :show, status: :ok, location: @option_for_item }
      else
        format.html { render :edit }
        format.json { render json: @option_for_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /option_for_items/1
  # DELETE /option_for_items/1.json
  def destroy
    @option_for_item.destroy
    respond_to do |format|
      format.html { redirect_to option_for_items_url, notice: 'Option for item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_option_for_item
      @option_for_item = OptionForItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def option_for_item_params
      params.require(:option_for_item).permit(:item_id, :item_type, :code, :name, :sort_order, :enabled)
    end
end
