class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_locale

  # Permit additional fields for user sign-up and account updates
  before_action :configure_permitted_parameters, if: :devise_controller?

  layout :layout_by_resource

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  protected

  def layout_by_resource
    if devise_controller?
      "application" # You can change this to a custom layout too
    else
      "application"
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation, :phone_number, :time_zone, :instagram, :x, :tiktok, :photo])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation, :current_password, :phone_number, :time_zone, :instagram, :x, :tiktok, :photo])
  end

  # Ensure the custom redirect after sign-up
  def after_sign_up_path_for(resource)
    root_path
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
