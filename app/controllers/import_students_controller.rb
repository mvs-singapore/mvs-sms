class ImportStudentsController < ApplicationController
  def create
    raise Exception.new('No file is uploaded') unless params["csv_upload_file"]
    input = params["csv_upload_file"]
    raise Exception.new('Please upload CSV file') if input.content_type != 'text/csv'
    StudentsImporter.execute(input.tempfile.path)
    redirect_to import_students_path, notice: 'Import success'
  rescue Exception => e
    redirect_to import_students_path, alert: e.message
  end
end
