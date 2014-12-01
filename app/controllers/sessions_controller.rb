class SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate!(
      :scope => resource_name,
      :recall => "#{controller_path}#failure")
    sign_in_and_redirect(resource_name, resource)
  end

  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    flash[:notice] = 'Signed in successfully.'
    return_values = {
      :success => true,
      :access_token => resource.janrain_access_token
    }
    unless params[:skip_redirect]
      return_values.merge!(:redirect_url => after_sign_in_path_for(resource))
    end
    return render :json => return_values
  end

  def failure
    return render :json => {:success => false, :errors => ["Login failed."]}
  end
end
