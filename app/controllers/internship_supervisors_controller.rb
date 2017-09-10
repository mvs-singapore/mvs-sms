class InternshipSupervisorsController < ApplicationController
  include Crudable

  RESOURCE_CLASS = InternshipSupervisor

  private

  def resource_params
    params.require(:internship_supervisor).permit(:name, :email, :contact_number, :internship_company_id)
  end

  def resources_path
    internship_supervisors_path
  end
end
