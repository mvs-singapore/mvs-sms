class StudentsController < ApplicationController
  before_action :fetch_student, only: [:show, :edit, :update, :destroy]

  def index
    @students = Student.all
  end

  def show
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)

    if @student.save
      redirect_to students_path, flash: { notice: 'Successfully created student' }
    else
      flash.now[:alert] = @student.errors.full_messages.join(" ")
      render :new
    end
  end

  def edit
  end

  def update
    if @student.update(student_params)
      redirect_to students_path, flash: { notice: 'Successfully updated student' }
    else
      flash.now[:alert] = @student.errors.full_messages.join(" ")
      render :edit
    end
  end

  def destroy
    if @student.destroy
      redirect_to students_path, flash: { notice: 'Successfully deleted student' }
    else
      redirect_to students_path, flash: { alert: @student.errors.full_messages.join(" ") }
    end
  end

  private

  def fetch_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:admission_year, :admission_no, :registered_at, :current_class, :status, :referred_by, :referral_notes,
                                    :surname, :given_name, :date_of_birth, :place_of_birth, :race, :nric, :citizenship, :gender, :sadeaf_client_reg_no,
                                    :highest_standard_passed, :medication_needed, :allergies)
  end

end
