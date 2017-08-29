class Admin::SchoolClassesController < ApplicationController
  before_action :is_admin?
  before_action :fetch_school_class, only: [:edit, :update, :destroy]

  def index
    @school_classes = SchoolClass.all
  end

  def new
    @school_class = SchoolClass.new
  end

  def create
    @school_class = SchoolClass.new(school_class_params)

    if @school_class.save
      redirect_to admin_school_classes_path, flash: { notice: 'Successfully created class'}
    else
      flash.now[:alert] = @school_class.errors.full_messages.join(" ")
      render :new
    end
  end

  def edit
  end

  def update
    if @school_class.update(school_class_params)
      redirect_to admin_school_classes_path, flash: { notice: 'Successfully updated class' }
    else
      flash.now[:alert] = @school_class.errors.full_messages.join(" ")
      render :edit
    end
  end

  def destroy
    if @school_class.destroy
      redirect_to admin_school_classes_path, flash: { notice: 'Successfully deleted class' }
    else
      redirect_to admin_school_classes_path, flash: { alert: @school_class.errors.full_messages.join(" ") }
    end
  end


  private

  def fetch_school_class
    @school_class = SchoolClass.find(params[:id])
  end

  def school_class_params
    params.require(:school_class).permit(:academic_year, :name, :year, :form_teacher_id)
  end

end
