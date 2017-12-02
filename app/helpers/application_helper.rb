module ApplicationHelper
  def bootstrap_class_for(flash_type)
    {
        success: "alert-success",
        error: "alert-error",
        alert: "alert-danger",
        notice: "alert-info"
    }[flash_type.to_sym] || flash_type.to_s
  end

  def bootstrap_glyphs_icon(flash_type)
    {
        success: "glyphicon-ok",
        error: "glyphicon-exclamation-sign",
        alert: "glyphicon-warning-sign",
        notice: "glyphicon-info-sign"
    }[flash_type.to_sym] || 'glyphicon-screenshot'
  end

  def datepicker_input f, field
      f.text_field field, class: 'form-control form-control-sm', placeholder: 'YYYY-MM-DD', :data => {:provide => 'datepicker', 'date-format' => 'yyyy-mm-dd',
                                                                                                  'date-autoclose' => 'true', 'date-orientation' => 'bottom auto'}
  end

  def csv_download_options(current_params)
    link_options = {format: "csv"}
    if current_params[:search].present?
      link_options.merge!(search: current_params[:search])
    elsif current_params[:academic_year].present?
      link_options.merge!(academic_year: current_params[:academic_year], class_name: current_params[:class_name])
    end

    link_options
  end

end
