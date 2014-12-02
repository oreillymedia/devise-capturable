module CapturableHelper
  def display_janrain_widget?
    [
      ['sessions', 'new'],
      ['passwords', 'reset']
    ].exclude? [params[:controller], params[:action]]
  end

  def devise_resource_name
    Devise.mappings.keys[0].to_s
  end
end
