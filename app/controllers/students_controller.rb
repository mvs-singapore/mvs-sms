class StudentsController < ApplicationController

  before_action :fetch_student, only: [:show, :edit, :update, :destroy]
  before_action :fetch_medical_history_master_list, only: [:new, :edit, :create, :update]
  before_action :fetch_cohort_classes, only: [:index]
  before_action :fetch_cloudinary, only: [:create, :update]

  def index
    if params[:search].present?
      @students = Student.search(params[:search]).order("created_at DESC")
    elsif params[:academic_year].present?
      @students = Student.filter_by_cohort_and_classes(params[:academic_year], params[:class_name])
      @class_names = SchoolClass.all.where(academic_year: params[:academic_year]).pluck('name')
    else
      @students = Student.all.order('surname')
    end
    respond_to do |format|
      format.html
      format.csv { send_data Student.as_csv(@students), filename: "students-#{Date.today}.csv" }
    end
  end

  def new
    @student = Student.new
    @student.past_education_records.new
    @student.point_of_contacts.new
    @student.internship_records.new
    # @student.remarks.new
    @student.financial_assistance_records.new
    @student.attachments.new
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
      flash.now[:alert] = @student.errors.full_messages.join("<br/>").html_safe
      render :new
    end
  end

  def update
    if @student.update(student_params)
      update_records(@student.student_disabilities, :disability_id, @student.disability_ids, medical_history_params[:disability_ids])
      update_records(@student.student_medical_conditions, :medical_condition_id, @student.medical_condition_ids, medical_history_params[:medical_condition_ids])

      redirect_to @student, flash: {notice: 'Successfully updated student'}
    else
      flash.now[:alert] = @student.errors.full_messages.join("<br/>").html_safe
      render :edit
    end
  end

  def edit
  end

  def destroy
    if @student.destroy
      redirect_to students_path, flash: {notice: 'Successfully deleted student'}
    else
      redirect_to students_path, flash: {alert: @student.errors.full_messages.join("<br/>").html_safe }
    end
  end

  private

  def fetch_student
    @student = Student.find(params[:id])
    @remarks_by_current_user = @student.remarks.where(user_id: current_user.id)
  end

  def fetch_medical_history_master_list
    @disabilities = Disability.all
    @medical_conditions = MedicalCondition.all
  end

  def fetch_cohort_classes
    @cohorts = SchoolClass.distinct.pluck(:academic_year)
    @class_names = SchoolClass.distinct.pluck(:name)
  end

  def student_params
    student_params = params.require(:student).permit(:admission_year, :admission_no, :registered_at, :current_class, :status, :referred_by, :referral_notes,
                                    :surname, :given_name, :date_of_birth, :place_of_birth, :race, :nric, :citizenship, :gender, :sadeaf_client_reg_no,
                                    :tshirt_size, :medication_needed, :allergies, :image_id,
                                    past_education_records_attributes: [:id, :school_name, :from_date, :to_date, :qualification, :highest_qualification, :_destroy],
                                    point_of_contacts_attributes: [:id, :surname, :given_name, :address, :postal_code, :race,
                                    :dialect, :languages_spoken, :id_number, :id_type, :date_of_birth, :place_of_birth,
                                    :nationality, :occupation, :home_number, :handphone_number, :office_number, :relationship, :_destroy],
                                    internship_records_attributes: [:id, :student_id, :internship_company_id, :internship_supervisor_id, :from_date,
                                    :to_date, :comments, :_destroy],
                                    financial_assistance_records_attributes: [:id, :assistance_type, :year_obtained, :duration, :_destroy],
                                    attachments_attributes: [:id, :document_type, :filename, :notes, :_destroy],
                                    remarks_attributes: [:id, :student_id, :user_id, :event_date, :category, :details, :created_at, :updated_at, :_destroy])

    if student_params[:remarks_attributes].present?
      student_params[:remarks_attributes].each do |_, remark|
        remark[:user_id] = remark[:user_id].blank? ? current_user.id : User.find_by(name: remark[:user_id]).id
      end
    end

    student_params
  end

  def medical_history_params
    params.require(:student).permit(disability_ids:[], medical_condition_ids:[])
  end

  def fetch_cloudinary
    if params[:image_id].present?
      preloaded = Cloudinary::PreloadedFile.new(params[:image_id])
      raise "Invalid upload signature" if !preloaded.valid?
      @student.image_id = preloaded.identifier
    end
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
