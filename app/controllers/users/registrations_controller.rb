class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?


  def new
    super # This ensures Devise's default new action is used
  end

  def create
    super
    if resource.persisted? && params[:user][:photo].present?
      resource.photo.attach(params[:user][:photo])
    end
  end

  def update_resource(resource, params)
    if params[:password].present?
      super
    else
      resource.update_without_password(params)
    end
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number, :photo, :instagram, :x, :tiktok, :time_zone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number, :photo, :instagram, :x, :tiktok, :time_zone])
  end
end
