class Admin::UsersController < ApplicationController
  before_action :is_admin?
  include Crudable

  RESOURCE_CLASS = User

  def create
    @user = RESOURCE_CLASS.new(resource_params)
    default_password = RESOURCE_CLASS.generate_random_password
    @user.password = default_password

    if @user.save
      NotificationsMailer.new_user(@user, default_password).deliver_now
      redirect_to resources_path, flash: { notice: 'Successfully created ' + self.class::RESOURCE_CLASS.to_s.titleize.downcase }
    else
      flash.now[:alert] = @user.errors.full_messages.join(" ")
      render :new
    end
  end

  private

  def resource_params
    params.require(:user).permit(:name, :email, :role_id)
  end

  def resources_path
    admin_users_path
  end
end
