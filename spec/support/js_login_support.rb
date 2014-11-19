module JsLoginSupport
  require_relative "wait_time_support"
  include WaitTimeSupport

  def js_login_attempt(email, password)
    reset_login_status

    # We expect these "find" calls to succeed, so we're willing to
    # wait as long as it takes for Janrain's widget to load.  It's
    # not uncommong for it to take 2-6 sec from Sebastopol.
    with_wait_time(test_js_login_load_wait_time) do
      fill_in 'capture_signIn_traditionalSignIn_emailAddress',
        :with => email
      fill_in 'capture_signIn_traditionalSignIn_password',
        :with => password
    end
    click_button("Sign In")
  end

  def reset_login_status
    # Ideally we'd click "Sign Out", but that doesn't seem to trigger the
    # logout process with Capybara/PhantomJS, and it wouldn't work on
    # "Unauthorized" pages.
    visit "/protected"
    page.evaluate_script('localStorage.clear()')
    # Prevent the localStorage key from getting restored by a Federate call,
    # so that we don't have to sleep before clearing localStorage.
    page.driver.reset!
    visit ENV['JANRAIN_FEDERATE_SERVER'] + "/static/server.html"
    page.evaluate_script('localStorage.clear()')
    page.driver.reset!
    visit "/protected"
    expect(current_path).to eq "/users/sign_in"
  end
end
