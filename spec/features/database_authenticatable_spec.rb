require 'spec_helper'

describe "Devise::DatabaseAuthenticatable", type: :feature do
  it "permits logged-out access to index" do
    visit "/"
    expect(page).to have_content "Index"
  end

  it "forbids logged-out access to protected" do
    visit "/protected"
    expect(page).not_to have_content "Protected"
    within "h2" do
      expect(page).to have_content "Log in"
    end
  end
end

