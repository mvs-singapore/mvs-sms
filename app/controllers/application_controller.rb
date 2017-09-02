class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  helper_method :is_admin?

  def authorize_admin
    unless is_admin?
      redirect_to root_path, flash: { alert: 'Unauthorized access' }
    end
  end

  def is_admin?
    current_user.role.super_admin?
  end

  def configure_permitted_parameters
    update_attrs = [:password, :password_confirmation, :current_password, :email, :name]
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  end

end
