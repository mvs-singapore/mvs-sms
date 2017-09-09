class MedicalConditionsController < ApplicationController
  before_action :fetch_medical_condition, only: [:edit, :update, :destroy]

  def index
    @medical_conditions = MedicalCondition.all
  end

  def new
    @medical_condition = MedicalCondition.new
  end

  def create
    @medical_condition = MedicalCondition.new(medical_condition_params)

    if @medical_condition.save
      redirect_to medical_conditions_path, flash: { notice: 'Successfully created medical condition'}
    else
      flash.now[:alert] = @medical_condition.errors.full_messages.join(" ")
      render :new
    end
  end

  def edit
  end

  def update
    if @medical_condition.update(medical_condition_params)
      redirect_to medical_conditions_path, flash: { notice: 'Successfully updated medical condition' }
    else
      flash.now[:alert] = @medical_condition.errors.full_messages.join(" ")
      render :edit
    end
  end

  def destroy
    if @medical_condition.destroy
      redirect_to medical_conditions_path, flash: { notice: 'Successfully deleted medical condition' }
    else
      redirect_to medical_conditions_path, flash: { alert: @medical_condition.errors.full_messages.join(" ") }
    end
  end

  private

  def fetch_medical_condition
    @medical_condition = MedicalCondition.find(params[:id])
  end

  def medical_condition_params
    params.require(:medical_condition).permit(:title)
  end
end
