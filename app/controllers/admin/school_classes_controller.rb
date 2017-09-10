class Admin::SchoolClassesController < ApplicationController

  include Crudable
  before_action :is_admin?

  RESOURCE_CLASS = SchoolClass
  
  private

  def resource_params
    params.require(:school_class).permit(:academic_year, :name, :year, :form_teacher_id)
  end

  def resources_path
    admin_school_classes_path
  end

end
