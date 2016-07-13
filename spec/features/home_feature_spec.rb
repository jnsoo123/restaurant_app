require "rails_helper"
require "spec_helper"
require "capybara/rspec"

feature "Home Interface" do

  let!(:owner1){FactoryGirl.create(:user, :name => "Joe", :admin => false)}
  let!(:rater1){FactoryGirl.create(:user, :name => "Jack", :admin => false)}
  let!(:cuisine1){FactoryGirl.create(:cuisine, :name => "Korean")}
    
  before(:each) do
    visit home_path
  end  
    
  context "Rated Restaurant Available" do
    let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "Some Restaurant", :user_id => owner1.id, :status => 'Accepted')}
    let!(:rating1){FactoryGirl.create(:rating, :restaurant_id => restaurant1.id, :user_id => rater1.id, :rate => 3)}
    let!(:location1){FactoryGirl.create(:location, :address => "Makati", :restaurant => restaurant1)}
    
    before(:each) do
      visit home_path
    end
    
    scenario "Display Top Rated Restaurant" do
      within(:css, "div#restaurants") do
        expect(page).to have_content("#{restaurant1.name}")
      end
    end
    
    scenario "Display Restaurant Profile of Top Rated Restaurant" do
      within(:css, "div#restaurants") do
          first('.hvr-grow > a').click
      end
      expect(page.has_css?('.module')).to be true
      expect(page.has_css?('div#picture-part')).to be true
      expect(page.has_css?('div#announcement_area')).to be true
      expect(page.has_css?('div#reviews_area')).to be true
    end
  end
  
end