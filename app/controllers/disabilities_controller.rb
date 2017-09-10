class DisabilitiesController < ApplicationController
  include Crudable

  private

  def resource_params
    params.require(:disability).permit(:title)
  end

  def resources_path
    disabilities_path
  end

  def resource_class
    Disability
  end
end
