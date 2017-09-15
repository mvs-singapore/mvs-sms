class PastEducationRecordsController < ApplicationController
  before_action :set_student
  before_action :set_past_education_record, only: [:edit, :update, :destroy]

  def new
    @past_education_record = @student.past_education_records.new
  end

  def create
    @past_education_record = @student.past_education_records.new(past_education_record_params)

    if @past_education_record.save
      redirect_to @student, flash: {notice: 'Successfully created past education record' }
    else
      flash.now[:alert] = @past_education_record.errors.full_messages.join(" ")
      render :new
    end
  end

  def edit
  end

  def update
    if @past_education_record.update(past_education_record_params)
      redirect_to @student, flash: {notice: 'Successfully updated past education record'}
    else
      flash.now[:alert] = @past_education_record.errors.full_messages.join(" ")
      render :edit
    end
  end

  def destroy
    if @past_education_record.destroy
      redirect_to @student, flash: {notice: 'Successfully deleted past education record'}
    else
      redirect_to @student, flash: {alert: @past_education_record.errors.full_messages.join(" ") }
    end
  end


  private

  def set_student
    @student = Student.find(params[:student_id])
  end

  def set_past_education_record
    @past_education_record = @student.past_education_records.find(params[:id])
  end

  def past_education_record_params
    params.require(:past_education_record).permit(:student_id, :school_name, :from_date, :to_date, :qualification)
  end

end
