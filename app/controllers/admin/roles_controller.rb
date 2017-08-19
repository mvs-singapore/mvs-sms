class Admin::RolesController < ApplicationController
  def index

  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(role_params)

    if @role.save
      redirect_to admin_roles_path, flash: { notice: 'Successfully created role'}
    else
      flash.now[:alert] = @role.errors.full_messages.join(" ")
      render :new
    end
  end

  private

  def role_params
    params.require(:role).permit(:name)
  end
end
