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

  def janrain_css_url
    if Devise.janrain_css_url
      Devise.janrain_css_url.split(' ').to_json
    else
      ['//cdn.oreillystatic.com/members/css/janrain.min.css'].to_json
    end
  end

  def janrain_mobile_css_url
    if Devise.janrain_mobile_css_url
      Devise.janrain_mobile_css_url.split(' ').to_json
    else
      ['//cdn.oreillystatic.com/members/css/janrain-mobile.min.css'].to_json
    end
  end

  def janrain_widget_url
    Devise.janrain_widget_url ||
      '//cdn.oreillystatic.com/members/js/widgets/login-widget.min.js'
  end
end
