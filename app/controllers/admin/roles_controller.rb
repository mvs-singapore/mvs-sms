class Admin::RolesController < ApplicationController
  before_action :is_admin?
  before_action :fetch_role, only: [:edit, :update, :destroy]

  def index
    @roles = Role.all
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

  def edit
  end

  def update
    if @role.update(role_params)
      redirect_to admin_roles_path, flash: { notice: 'Successfully updated role' }
    else
      flash.now[:alert] = @role.errors.full_messages.join(" ")
      render :edit
    end
  end

  def destroy
    if @role.destroy
      redirect_to admin_roles_path, flash: { notice: 'Successfully deleted role' }
    else
      redirect_to admin_roles_path, flash: { alert: @role.errors.full_messages.join(" ") }
    end
  end

  private

  def fetch_role
    @role = Role.find(params[:id])
  end

  def role_params
    params.require(:role).permit(:name)
  end
end
