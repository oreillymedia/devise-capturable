module CapturableHelper
  def display_logout?(resource_name)
    clean_url = request.original_url.split('?')[0]
    [new_session_url(resource_name), "#{root_url}/#{resource_name}/reset_password"].exclude? clean_url
  end
end