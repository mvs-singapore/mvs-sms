class Admin::RolesController < ApplicationController
  include Crudable

  before_action :authorize_admin
  RESOURCE_CLASS = Role

  private

  def resource_params
    params.require(:role).permit(:name)
  end

  def resources_path
    admin_roles_path
  end
end
