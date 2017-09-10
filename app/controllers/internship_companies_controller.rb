class InternshipCompaniesController < ApplicationController
  include Crudable

  RESOURCE_CLASS = InternshipCompany

  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]

  def show
  end

  private

  def resource_params
    params.require(:internship_company).permit(:name, :address, :postal_code)
  end

  def resources_path
    internship_companies_path
  end
end
