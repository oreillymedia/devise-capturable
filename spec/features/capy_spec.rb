require 'spec_helper'

describe "UI via Capybara" do
  it "renders something" do
    visit "/"
    expect(page).to have_content "No route matches"
  end
end
