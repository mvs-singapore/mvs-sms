class DisabilitiesController < ApplicationController
  include Crudable

  RESOURCE_CLASS = Disability

  private

  def resource_params
    params.require(:disability).permit(:title)
  end

  def resources_path
    disabilities_path
  end
end
