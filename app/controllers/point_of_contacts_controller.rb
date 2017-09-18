class PointOfContactsController < ApplicationController

  before_action :set_student, only: [:edit, :update, :destroy]

  def new
    @student = Student.find(params[:student_id])
    @point_of_contact = @student.point_of_contacts.new
  end

  def create
    @student = Student.find(params[:student_id])
    @point_of_contact = @student.point_contacts.new(point_of_contact_params)

    if @point_of_contact.save
      redirect_to @student, flash: {notice: 'Successfully created point of contact' }
    else
      flash.now[:alert] = @point_of_contact.errors.full_messages.join(" ")
      render :new
    end
  end

  def edit
  end

  def update
    if @point_of_contact.update(point_of_contact_params)
      redirect_to @student, flash: {notice: 'Successfully updated point of contact'}
    else
      flash.now[:alert] = @point_of_contact.errors.full_messages.join(" ")
      render :edit
    end
  end

  def destroy
    if @point_of_contact.destroy
      redirect_to @student, flash: {notice: 'Successfully deleted point of contact'}
    else
      redirect_to @student, flash: {alert: @point_of_contact.errors.full_messages.join(" ") }
    end
  end


  private

  def set_student
    @student = Student.find(params[:student_id])
    @point_of_contact = @student.point_of_contacts.find(params[:id])
  end

  def point_of_contact_params
    params.require(:point_of_contact).permit(:surname, :given_name, :address, :postal_code, :race, :dialect, :languages_spoken, :id_number, :id_type,
                                             :date_of_birth, :place_of_birth, :nationality, :occupation, :home_number, :handphone_number,
                                             :office_number, :relationship)
  end

end
