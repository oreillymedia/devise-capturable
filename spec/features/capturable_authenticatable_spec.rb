require 'spec_helper'
require 'support/js_login_support'

describe "Devise::CapturableAuthenticatable", type: :feature do
  include JsLoginSupport

  it "permits logged-out access to index", js: true  do
    visit "/"
    expect(page).to have_content "Index"
  end

  it "requires login for protected pages", js: true do
    reset_login_status
    visit "/protected"
    expect(page).not_to have_content "Protected"
    expect(page).to have_content "Sign In"
    js_login_attempt test_user_email, test_user_password
    expect(page).not_to have_content "Sign In"
    expect(page).to have_content "Protected"
  end
end

