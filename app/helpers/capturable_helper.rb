module CapturableHelper
  def display_logout?
    [
      ['sessions', 'sign_in'],
      ['passwords', 'reset']
    ].exclude? [params[:controller], params[:action]]
  end
end
