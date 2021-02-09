class Company::LineRichmenuImagesController < ApplicationController
  before_action :set_line_richmenu_image, only: [:show, :edit, :update, :destroy]

  def index
    @line_richmenu_images = company.line_richmenu_images
  end

  def new
    @line_richmenu_image = LineRichmenuImage.new
  end

  def create
    @line_richmenu_image = company.line_richmenu_images.new
    @line_richmenu_image.attributes = line_richmenu_image_params

    if @line_richmenu_image.save
      redirect_to company_line_richmenu_image_path(company.code, @line_richmenu_image), notice: '登録完了'
    else
      render :edit, notice: '入力内容にエラーがあります。'
    end
  end

  def show
  end

  def edit
  end

  def update
    @line_richmenu_image.attributes = line_richmenu_image_params

    if @line_richmenu_image.save
      redirect_to company_line_richmenu_image_path(company.code, @line_richmenu_image), notice: '登録完了'
    else
      render :edit, notice: '入力内容にエラーがあります。'
    end
  end

  def destroy
    render plain: 'destroy'
  end

  private
    def set_line_richmenu_image
      @line_richmenu_image ||= company.line_richmenu_images.find(params[:id])
    end

    def line_richmenu_image_params
      params.require(:line_richmenu_image).permit(
        :memo,
        :image_file,
      )
    end
end
