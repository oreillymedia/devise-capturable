module CapturableHelper
  def display_janrain_widget?
    [
      ['sessions', 'new'],
      ['passwords', 'reset']
    ].exclude? [params[:controller], params[:action]]
  end
end
