require "spec_helper"

describe 'View Helpers' do

  it "should generate correct link" do
    class Testing
      include Devise::Capturable::Helpers
    end
    test = Testing.new
    link = test.link_to_capturable("Login")
    expect(link).to eq '<a href="#" class="capture_modal_open" id="capture_signin_link">Login</a>'
  end

end
