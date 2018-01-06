class PagesController < ApplicationController
  def index
    redirect_to students_path if user_signed_in? && is_admin?
  end
end
