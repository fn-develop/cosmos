class Company::CalendarsController < ApplicationController
  def index

  end

  def create
    render plain: params[:action]
  end

  def show
    render plain: params[:action]
  end

  def etit
    render plain: params[:action]
  end

  def update
    render plain: params[:action]
  end

  def destroy
    render plain: params[:action]
  end

  private
end
