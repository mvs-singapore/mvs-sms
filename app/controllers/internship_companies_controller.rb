class InternshipCompaniesController < ApplicationController
  before_action :fetch_internship_company, only: [:edit, :update, :destroy, :show]	

	def index
		 @internship_company = InternshipCompany.all
  end
	
	def new
    @internship_company = InternshipCompany.new
  end

  def create
    @internship_company = InternshipCompany.new(internship_company_params)

    if @internship_company.save
      redirect_to internship_companies_path, flash: { notice: 'Successfully created internship company'}
    else
      flash.now[:alert] = @internship_company.errors.full_messages.join(" ")
      render :new
    end
  end

  def edit		
  end
    
  def show
  end

  def update
    if @internship_company.update(internship_company_params)
      redirect_to internship_companies_path, flash: { notice: 'Successfully updated internship company' }
    else
      flash.now[:alert] = @internship_company.errors.full_messages.join(" ")
      render :edit
    end
  end
		
	def destroy
    if @internship_company.destroy
      redirect_to internship_companies_path, flash: { notice: 'Successfully deleted internship company' }
    else
      redirect_to internship_companies_path, flash: { alert: @internship_company.errors.full_messages.join(" ") }
    end
  end

	private
	
	def fetch_internship_company
    @internship_company = InternshipCompany.find(params[:id])
  end
	
	def internship_company_params
    params.require(:internship_company).permit(:name, :address, :postal_code)
	end
	
end

