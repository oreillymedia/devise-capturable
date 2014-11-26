class PasswordsController < Devise::PasswordsController

  def edit ; end

  protected
  # Overwrite Devise's method to check if a Janrain password reset
  # code is provided in the request, instead of Devise's
  # reset_password_token
  def assert_reset_token_passed
    if params[:code].blank?
      set_flash_message(:alert, :no_token)
      redirect_to new_session_path(resource_name)
    end
  end
end
