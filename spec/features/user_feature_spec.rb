require "rails_helper"
require "spec_helper"
require "capybara/rspec"

feature "User Interface" do
  let!(:owner1){FactoryGirl.create(:user, :name => "Joelle", :admin => false)}
  let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "Some Restaurant", :user_id => owner1.id, :status => 'Accepted')}
  let!(:location1){FactoryGirl.create(:location, :address => "Makati", :restaurant => restaurant1)}
  let!(:user1){FactoryGirl.create(:user, :name => "Fredrickson", :username => "myuser", :admin => false)}
  let!(:picture1){FactoryGirl.create(:picture, :restaurant => restaurant1, :user => user1, :pic => File.open("#{Rails.root}/spec/support/sisig.jpg"), :status => true)}
  let!(:ratings1){FactoryGirl.create(:rating, :rate => 2, :restaurant => restaurant1, :user => user1)}
  
  
  before(:each) do
    visit home_path
    within(:css, '.navbar-right') do
      find_link("Login").click
    end
    fill_in 'Username', :with => user1.username
    fill_in 'password', :with => user1.password
    find_button('Login').click
    sleep 6
    find_link("#{user1.name}").click
    find_link("My Profile").click
  end
  
  context "Logged in as user" do
    scenario "Display User Profile Page" do
      expect(page.current_path).to eq(user_profile_path(user1.id))
    end
    
    scenario "Edit Profile" do
      find_link("Edit Profile").click
      fill_in 'user_username', :with => "Fred321"
      fill_in 'user_current_password', :with => user1.password
      find_button("Update").click
      user1.reload
      expect(page).to have_content(user1.username)
    end
    
    scenario "Display Fudline" do
      within(:css, '#user_reviews_area') do
        expect(page).to have_content(ratings1.rate)
        expect(page).to have_content(ratings1.comment)
      end
    end
    
    scenario "Display Reviewed Restaurants" do
      find("a[data-target='#reviewed']").click
      within(:css, "#reviewed > div > a > div > header > h3") do
        expect(page).to have_content(restaurant1.name)
      end
    end
    
    scenario "Display Uploaded Photo" do
      find("a[data-target='#photos']").click
      within(:css, "#photos > div > a") do
        expect(page).to have_css('.img-responsive')
      end      
    end
  end
  
end