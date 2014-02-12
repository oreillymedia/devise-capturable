require "spec_helper"
require File.join(File.dirname(__FILE__), '..', 'lib', 'devise_capturable', 'view_helpers')

describe 'View Helpers' do

  it "should generate correct link" do
    class Testing
      include Devise::Capturable::Helpers
    end
    test = Testing.new
    link = test.link_to_capturable("Login")
    link.should include "Login"
    link.should include 'class="capture_modal_open"'
    link.should include 'id="capture_signin_link"'
    link.should include 'href="#"'
  end

end