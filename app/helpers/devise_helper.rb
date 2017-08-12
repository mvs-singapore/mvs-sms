module DeviseHelper
  def devise_error_messages!
    return "" unless devise_error_messages?

    html = <<-HTML
    <div class="alert alert-danger" role="alert">
      Email does not exist. Please try again.
    </div>
    HTML

    html.html_safe
  end

  def devise_error_messages?
    !resource.errors.empty?
  end

end
