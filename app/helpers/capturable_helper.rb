module CapturableHelper
  def display_logout?(resource_name)
    clean_url = request.original_url.split('?')[0]
    [new_session_url(resource_name), reset_password_url(resource_name)].exclude? clean_url
  end
end
