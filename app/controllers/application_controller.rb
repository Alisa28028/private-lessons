class ApplicationController < ActionController::Base
  before_action :restrict_custom_domain
  before_action :authenticate_user!
  before_action :set_locale

  # Permit additional fields for user sign-up and account updates
  before_action :configure_permitted_parameters, if: :devise_controller?

  layout :layout_by_resource

  private

  # Restrict access to custom domain only
  def restrict_custom_domain
    if request.host == "privatelesson.app" || request.host == "www.privatelesson.app"
      authenticate_or_request_with_http_basic("App in private mode") do |username, password|
        username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
      end
    end
  end

  # Set locale
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # Permit Devise parameters
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation, :phone_number, :time_zone, :instagram, :x, :tiktok, :photo])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation, :current_password, :phone_number, :time_zone, :instagram, :x, :tiktok, :photo])
  end

  # Set layout depending on controller
  protected

  def layout_by_resource
    "application" # can customize if needed
  end

  # Custom redirect after sign-up
  def after_sign_up_path_for(resource)
    root_path
  end

  # Default URL options for locale
  def default_url_options
    { locale: I18n.locale }
  end
end
