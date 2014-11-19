module WaitTimeSupport
  # This wait time can vary depending on your network characteristics
  # It should be applied to browser testing that needs to go over
  # the network to third-parties such as Janrain.
  def test_js_login_load_wait_time
    (ENV['TEST_JS_LOGIN_LOAD_WAIT_TIME'] || "10").to_i
  end

  def test_js_load_wait_time
    (ENV['TEST_JS_LOAD_WAIT_TIME'] || "5").to_i
  end

  def with_wait_time(wait_time)
    orig_wait = Capybara.default_wait_time
    begin
      Capybara.default_wait_time = wait_time
      yield
    ensure
      Capybara.default_wait_time = orig_wait
    end
  end
end
