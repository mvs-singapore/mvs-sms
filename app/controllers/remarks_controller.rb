class RemarksController < ApplicationController
  before_action :set_student
  before_action :set_remark, only: [:edit, :update, :destroy]

  def new
    @student = Student.find(params[:student_id])
    @remark = @student.remarks.new
  end

  def create
    @student = Student.find(params[:student_id])
    @remark = @student.remarks.new(remark_params)
    @remark.user = current_user

    if @remark.save
      redirect_to @student, flash: {notice: 'Successfully created remark' }
    else
      flash.now[:alert] = @remark.errors.full_messages.join(" ")
      render :new
    end
  end

  def edit
  end

  def update
    if @remark.update(remark_params)
      redirect_to @student, flash: {notice: 'Successfully updated remark'}
    else
      flash.now[:alert] = @remark.errors.full_messages.join(" ")
      render :edit
    end
  end

  def destroy
    if @remark.destroy
      redirect_to @student, flash: {notice: 'Successfully deleted remark'}
    else
      redirect_to @student, flash: {alert: @remark.errors.full_messages.join(" ") }
    end
  end


  private

  def set_student
    @student = Student.find(params[:student_id])
    @remark = @student.remark.find(params[:id])
  end

  def remark_params
    params.require(:remark).permit(:event_date, :category, :details)
  end

end
