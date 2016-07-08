require "rails_helper"
require "spec_helper"
require "capybara/rspec"

feature "Restaurant Interface" do

  before(:each) do
    visit home_path
  end
  
  context "Logged in" do
    
  end
  
  context "Not Logged in" do
    context "No Restaurants Yet" do
      scenario "Display No Restaurants Available" do
        expect(page).to have_content("No Restaurants available yet")
      end
    end
  end
end