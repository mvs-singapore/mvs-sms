class InternshipRecordsController < ApplicationController
  before_action :set_student
  before_action :set_internship_record, only: [:edit, :update, :destroy]

  def new
    @internship_record = @student.internship_records.new
  end

  def create
    @internship_record = @student.internship_records.new(internship_record_params)

    if @internship_record.save
      redirect_to @student, flash: {notice: 'Successfully created internship record' }
    else
      flash.now[:alert] = @internship_record.errors.full_messages.join(" ")
      render :new
    end
  end

  def edit
  end

  def update
    if @internship_record.update(past_education_record_params)
      redirect_to @student, flash: {notice: 'Successfully updated internship record'}
    else
      flash.now[:alert] = @internship_record.errors.full_messages.join(" ")
      render :edit
    end
  end

  def destroy
    if @internship_record.destroy
      redirect_to @student, flash: {notice: 'Successfully deleted internship record'}
    else
      redirect_to @student, flash: {alert: @internship_record.errors.full_messages.join(" ") }
    end
  end


  private

  def set_student
    @student = Student.find(params[:student_id])
  end

  def set_internship_record
    @internship_record = @student.internship_records.find(params[:id])
  end

  def internship_record_params
    params.require(:internship_record).permit(:student_id, :internship_company_id, :internship_supervisor_id, :from_date,
                                    :to_date, :comments)
  end

end
