# frozen_string_literal: true

class Auth::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  layout 'login'

  # GET /resource/sign_in
  def new
    raise CanCan::AccessDenied if company.blank?
    super
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private
    def company
      @company ||= Company.find_by(code: params[:company_code])
    end

    def after_sign_out_path_for(resource)
      new_user_session_path(params[:company_code])
    end

    def after_sign_in_path_for(resource)
      customers_path(params[:company_code])
    end
end
