class InternshipSupervisorsController < ApplicationController
  before_action :fetch_supervisor, only: [:edit, :update, :destroy]

  def index
    @internship_supervisors = InternshipSupervisor.all
  end

  def new
    @internship_supervisor = InternshipSupervisor.new
  end

  def create
    @internship_supervisor = InternshipSupervisor.new(internship_supervisor_params)
  
    if @internship_supervisor.save
      redirect_to internship_supervisors_path, flash: { notice: 'Successfully created internship supervisor' }
    else
      flash.now[:alert] = @internship_supervisor.errors.full_messages.join(" ")
      render :new
    end
  end

  def edit
  end

  def update
    if @internship_supervisor.update(internship_supervisor_params)
      redirect_to internship_supervisors_path, flash: { notice: 'Successfully updated internship supervisor' }
    else
      flash.now[:alert] = @internship_supervisor.errors.full_messages.join(" ")
      render :edit
    end
  end

  def destroy
    if @internship_supervisor.destroy
      redirect_to internship_supervisors_path, flash: { notice: 'Successfully deleted internship supervisor' }
    else
      redirect_to internship_supervisors_path, flash: { alert: @internship_supervisor.errors.full_messages.join(" ") }
    end
  end

  private

  def fetch_supervisor
    @internship_supervisor = InternshipSupervisor.find(params[:id])
  end

  def internship_supervisor_params
    params.require(:internship_supervisor).permit(:name, :email, :contact_number, :internship_company_id)
  end
end
