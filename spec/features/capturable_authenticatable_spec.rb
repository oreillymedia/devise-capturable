require 'spec_helper'

describe "Devise::CapturableAuthenticatable", type: :feature do
  it "permits logged-out access to index" do
    visit "/"
    expect(page).to have_content "Index"
  end

  it "requires login for protected pages", js: true do
    visit "/protected"
    expect(page).not_to have_content "Protected"
    within "h2" do
      expect(page).to have_content "Log in"
    end
    fill_in "Email", :with => test_user_email
    fill_in 'Password',:with => test_user_password
    click_button("Log in")
    expect(page).not_to have_content "Log in"
    expect(page).to have_content "Protected"
  end
end

