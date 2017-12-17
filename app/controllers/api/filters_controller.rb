class Api::FiltersController < ApplicationController

  def classes_by_year
    classes = SchoolClass.where(academic_year: params[:academic_year])
    hash = {}
    classes.each do |c|
      hash.merge!(c.id => c.name)
    end
    render json: hash.to_json
  end

end
