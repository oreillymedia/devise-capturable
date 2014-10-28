require "spec_helper"

describe 'View Helpers' do

  it "should generate correct link" do
    class Testing
      include Devise::Capturable::Helpers
    end
    test = Testing.new
    link = test.link_to_capturable("Login")
    expect(link).to match(/^<a/)
    expect(link).to match(/href="#"/)
    expect(link).to match(/class="capture_modal_open"/)
    expect(link).to match(/id="capture_signin_link"/)
    expect(link).to match(/Login/)
    expect(link).to match(/<\/a>$/)
  end

end
