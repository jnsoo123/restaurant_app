require "rails_helper"
require "spec_helper"
require "capybara/rspec"

feature "Restaurant Interface" do
  let!(:owner1){FactoryGirl.create(:user, :name => "Joe", :admin => false)}
  let!(:cuisine1){FactoryGirl.create(:cuisine, :name => "Korean")}
  let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "Some Restaurant", :user_id => owner1.id, :status => 'Accepted')}
  let!(:location1){FactoryGirl.create(:location, :address => "Makati", :restaurant => restaurant1)}
  let!(:user1){FactoryGirl.create(:user, :name => "Fred", :admin => false)}

  before(:each) do
    visit home_path
    within(:css, '.navbar-right') do
      click_link "Login"
    end
    fill_in 'Username', :with => user1.username
    fill_in 'password', :with => user1.password
    click_button('Login')
  end

end
