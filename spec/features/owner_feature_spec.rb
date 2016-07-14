require "rails_helper"
require "spec_helper"
require "capybara/rspec"

feature "User Interface" do
  let!(:owner1){FactoryGirl.create(:user, :name => "Joe", :admin => false)}
  let!(:cuisine1){FactoryGirl.create(:cuisine, :name => "Korean")}
  let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "Some Restaurant", :user_id => owner1.id, :status => 'Accepted')}
  let!(:location1){FactoryGirl.create(:location, :address => "Makati", :restaurant => restaurant1)}
  
  before(:each) do
    visit home_path
    within(:css, '.navbar-right') do
      click_link "Login"
    end
    fill_in 'Username', :with => owner1.username
    fill_in 'password', :with => owner1.password
    click_button('Login')
  end
  
  
  context "Owner Interface" do
    before(:each) do
      click_link "#{owner1.name}"
      click_link "My Restaurants"
    end
    
    context "Restaurant Page" do
      before(:each) do
        find(:xpath, '//*[@id="dashboard-owner"]/div/div[2]/div/div[2]/div[1]/a').click
      end
      
      scenario "Display Restaurant Edit Page" do
        expect(page).to have_content("Edit Information")
        expect(page).to have_content("Edit Map Location")
        expect(page.current_path == owner_resto_edit_path(restaurant1.id)).to be true
      end
      
      scenario "Edit Restaurant" do
        fill_in "restaurant_contact", with: "I changed this"
        click_button "Update Restaurant"
        expect(find("#restaurant_contact").value).to eq("I changed this")
      end
    end
    
    context "Add Restaurant Page" do
      before(:each) do
        click_link "Add Restaurants"
      end
      
      scenario "Displays Add Restaurant Page" do
        expect(page).to have_content("Create New Restaurant")
      end
      
      scenario "Add Restaurant" do
        
      end
    end
        
    scenario "Messages Page" do
      click_link "Messages"
      expect(page).to have_content("My Messages")
    end
    
    scenario "Return to Home Page" do
      click_link "Go Back to Mainpage"
      expect(page.current_path == home_path).to be true
    end
  end
  
  
end