class DisabilitiesController < ApplicationController
  before_action :fetch_disability, only: [:edit, :update, :destroy]

  def index
    @disabilities = Disability.all
  end

  def new
    @disability = Disability.new
  end

  def create
    @disability = Disability.new(disability_params)

    if @disability.save
      redirect_to disabilities_path, flash: { notice: 'Successfully created disability'}
    else
      flash.now[:alert] = @disability.errors.full_messages.join(" ")
      render :new
    end
  end

  def edit
  end

  def update
    if @disability.update(disability_params)
      redirect_to disabilities_path, flash: { notice: 'Successfully updated disability' }
    else
      flash.now[:alert] = @disability.errors.full_messages.join(" ")
      render :edit
    end
  end

  def destroy
    if @disability.destroy
      redirect_to disabilities_path, flash: { notice: 'Successfully deleted disability' }
    else
      redirect_to disabilities_path, flash: { alert: @disability.errors.full_messages.join(" ") }
    end
  end

  private

  def fetch_disability
    @disability = Disability.find(params[:id])
  end

  def disability_params
    params.require(:disability).permit(:title)
  end
end
