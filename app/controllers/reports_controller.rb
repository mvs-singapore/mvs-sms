class ReportsController < ApplicationController
  def index
    if params[:report]
      @report = Report.new(report_params)
    else
      @report = Report.new
    end

    respond_to do |format|
      format.html
      format.csv { send_data Student.as_csv(@report.search_students), filename: "students-#{Date.today}.csv" }
    end
  end

  def report_params
    params.require(:report).permit(age: [], gender: [], nationality: [], disability: [], status: [], referred_by: [])
  end
end
