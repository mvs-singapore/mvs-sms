class StudentsController < ApplicationController
  include Crudable

  RESOURCE_CLASS = Student

  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]

  def show
  end
  
  private

  def resource_params
    params.require(:student).permit(:admission_year, :admission_no, :registered_at, :current_class, :status, :referred_by, :referral_notes,
                                    :surname, :given_name, :date_of_birth, :place_of_birth, :race, :nric, :citizenship, :gender, :sadeaf_client_reg_no,
                                    :highest_standard_passed, :medication_needed, :allergies)
  end

  def resources_path
    students_path
  end
end
