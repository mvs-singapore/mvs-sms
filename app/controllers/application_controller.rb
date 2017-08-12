class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  def is_admin?
    unless current_user.super_admin?
      redirect_to root_path, flash: { alert: 'Unauthorized access' }
    end
  end
end
