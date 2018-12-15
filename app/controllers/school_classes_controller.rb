class SchoolClassesController < ApplicationController

  include Crudable
  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]

  RESOURCE_CLASS = SchoolClass
  
  def show

  end

  private

  def resource_params
    params.require(:school_class).permit(:academic_year, :name, :year, :form_teacher_id, student_ids: [])
  end

  def resources_path
    school_classes_path
  end

end
