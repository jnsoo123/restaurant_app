require "rails_helper"
require "spec_helper"
require "capybara/rspec"

feature "Restaurant Interface" do

  let!(:owner1){FactoryGirl.create(:user, :name => "Joe", :admin => false)}
  let!(:rater1){FactoryGirl.create(:user, :name => "Jack", :admin => false)}

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
    context "Restaurants Available" do 
      let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "Resto", :user_id => owner1.id, :status => 'Accepted')}
      
      context "No Rated Restaurants" do
        scenario "Display No Restaurants Available" do
          expect(page).to have_content("No Restaurants available yet")
        end
      end
      
      context "Rated Restaurants Available" do
        let!(:rating1){FactoryGirl.create(:rating, :restaurant_id => restaurant1.id, :user_id => rater1.id, :rate => 3)}
      
        scenario "Display Top Rated Restaurants" do
          within(:css, "div#restaurants") do
            puts "THIS IS THE COUNT: #{Rating.count} #{Rating.last.inspect} #{Restaurant.count} #{Restaurant.last.inspect}"
            expect(page).to have_content("#{Restaurant.last.name}")
          end
        end
      end
      
    end
  end
  
end