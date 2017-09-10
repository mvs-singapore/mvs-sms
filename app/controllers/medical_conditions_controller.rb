class MedicalConditionsController < ApplicationController
  include Crudable
  
  RESOURCE_CLASS = MedicalCondition

  private

  def resource_params
    params.require(:medical_condition).permit(:title)
  end

  def resources_path
    medical_conditions_path
  end
end
