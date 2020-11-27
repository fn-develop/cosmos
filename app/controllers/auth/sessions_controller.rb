# frozen_string_literal: true

class Auth::SessionsController < Devise::SessionsController
  layout 'temporary'

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
      homes_path
    end

    def after_sign_in_path_for(resource)
      homes_path
    end

    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in, keys: [:company_id])
    end
end
