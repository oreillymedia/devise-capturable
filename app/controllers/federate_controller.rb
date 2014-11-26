class FederateController < DeviseController

  prepend_before_filter :require_no_authentication

  def xd_receiver
    render :layout => false
  end
end
