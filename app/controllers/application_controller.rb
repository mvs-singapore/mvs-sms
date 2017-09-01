class ApplicationController < ActionController::Base
  before_action :authenticate_user!
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
end
