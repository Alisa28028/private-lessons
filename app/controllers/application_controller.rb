class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:home, :new, :create, :index]

  # Permit additional fields for user sign up and account updates
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Permit name, email, password and password confirmation during sign up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation, :phone_number, :time_zone, :instagram, :x, :tiktok, :photo])

    # If you want to permit these fields during account update as well
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation, :current_password, :phone_number, :time_zone, :instagram, :x, :tiktok, :photo])
  end
    # Ensure the custom redirect after sign up
    def after_sign_up_path_for(resource)
      # Redirect to the home page or any other page
      root_path
    end
end
