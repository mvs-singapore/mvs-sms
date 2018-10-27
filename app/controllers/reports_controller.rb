class ReportsController < ApplicationController
  def index
    if params[:report]
      @report = Report.new(report_params)
    else
      @report = Report.new
    end
  end

  def report_params
    params.require(:report).permit(age: [], gender: [], nationality: [], disability: [], status: [], referred_by: [])
  end
end
