class StudentsController < ApplicationController

  before_action :fetch_student, only: [:show, :edit, :update, :destroy]
  before_action :fetch_medical_history_master_list, only: [:new, :edit, :create, :update]

  def index
    @students = Student.all
  end

  def new
    @student = Student.new
    @student.past_education_records.new
    @student.point_of_contacts.new
  end

  def create
    @student = Student.new(student_params)

    medical_history_params[:disability_ids].reject(&:blank?).each do |disability_id|
      @student.student_disabilities.build(disability_id: disability_id)
    end

    medical_history_params[:medical_condition_ids].reject(&:blank?).each do |condition_id|
      @student.student_medical_conditions.build(medical_condition_id: condition_id)
    end

    if @student.save
      redirect_to students_path, flash: {notice: 'Successfully created student'}
    else
      flash.now[:alert] = @student.errors.full_messages.join(" ")
      render :new
    end
  end

  def update
    if @student.update(student_params)
      update_records(@student.student_disabilities, :disability_id, @student.disability_ids, medical_history_params[:disability_ids])
      update_records(@student.student_medical_conditions, :medical_condition_id, @student.medical_condition_ids, medical_history_params[:medical_condition_ids])

      redirect_to @student, flash: {notice: 'Successfully updated student'}
    else
      flash.now[:alert] = @student.errors.full_messages.join(" ")
      render :edit
    end
  end

  def edit
  end

  def destroy
    if @student.destroy
      redirect_to students_path, flash: {notice: 'Successfully deleted student'}
    else
      redirect_to students_path, flash: {alert: @student.errors.full_messages.join(" ") }
    end
  end

  private

  def fetch_student
    @student = Student.find(params[:id])
  end

  def fetch_medical_history_master_list
    @disabilities = Disability.all
    @medical_conditions = MedicalCondition.all
  end

  def student_params
    params.require(:student).permit(:admission_year, :admission_no, :registered_at, :current_class, :status, :referred_by, :referral_notes,
                                    :surname, :given_name, :date_of_birth, :place_of_birth, :race, :nric, :citizenship, :gender, :sadeaf_client_reg_no,
                                    :highest_standard_passed, :medication_needed, :allergies,
                                    past_education_records_attributes: [:id, :school_name, :from_date, :to_date, :qualification],
                                    point_of_contacts_attributes: [:id, :surname, :given_name, :address, :postal_code, :race,
                                    :dialect, :languages_spoken, :id_number, :id_type, :date_of_birth, :place_of_birth,
                                    :nationality, :occupation, :home_number, :handphone_number, :office_number, :relationship, :_destroy])
  end

  def medical_history_params
    params.require(:student).permit(disability_ids:[], medical_condition_ids:[])
  end

  def resources_path
    students_path
  end

  def update_records(associated_records, search_field, original_list, updated_list)
    updated_list = updated_list.reject(&:blank?).map(&:to_i).sort
    original_list = original_list.sort

    unless original_list == updated_list
      items_to_remove = original_list - updated_list
      items_to_add = updated_list - original_list

      items_to_remove.each do |item_id|
        associated_records.where(search_field => item_id).destroy_all
      end

      items_to_add.each do |item_id|
        associated_records.create(search_field => item_id)
      end
    end
  end
end
