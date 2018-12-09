class Admin::ImportStudentsController < ApplicationController
  before_action :authorize_admin
 
  def create
    raise Exception.new('No file is uploaded') unless params["csv_upload_file"]
    input = params["csv_upload_file"]
    raise Exception.new('Please upload CSV file') if input.content_type != 'text/csv'
    StudentsImporter.new(input.tempfile.path).execute
    redirect_to admin_import_students_path, notice: 'Import success'
  rescue => e
    redirect_to admin_import_students_path, alert: e.message
  end
end
