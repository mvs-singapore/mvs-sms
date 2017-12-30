class AttendancesController < ApplicationController

  before_action :fetch_cohort_classes, only: [:index, :new, :create, :update]

  def index

    #respond_to do |format|
      #format.html
      #format.csv { send_data Student.as_csv(@students), filename: "students-#{Date.today}.csv" }
    #end
  end

  def new
    @attendance = Attendance.new
    @students = Student.all.order('created_at DESC')
    # if params[:search].present?
    #   @students = Student.search(params[:search]).order("created_at DESC")
    # elsif params[:academic_year].present?
    #   @students = Student.filter_by_cohort_and_classes(params[:academic_year], params[:class_name])
    # else
    #   @students = Student.all.order('created_at DESC')
    #end
  end

  def create
    @attendance = Attendance.new(attendance_params)
byebug
    if @attendance.save
      byebug
      redirect_to attendances_path, flash: {notice: 'Successfully updated attendance'}
    else
      flash.now[:alert] = @attendance.errors.full_messages.join("<br/>").html_safe
      byebug
      render :new
    end
  end

  def update
    @attendance = Attendance.new(attendance_params)

    if @attendance.save
      redirect_to new_attendance_path, flash: {notice: 'Successfully updated attendance'}
    else
      flash.now[:alert] = @attendance.errors.full_messages.join("<br/>").html_safe
      render :new
    end
  end

  private

  def attendance_params
    params.require(:attendance).permit(:attendance_status,:reason, :school_class_id, student_ids: [])
  end

    def fetch_cohort_classes
    @cohorts = SchoolClass.distinct.pluck(:academic_year)
    @class_names = SchoolClass.distinct.pluck(:name)
  end
end