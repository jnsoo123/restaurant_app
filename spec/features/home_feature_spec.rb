require "rails_helper"
require "spec_helper"
require "capybara/rspec"

feature "Home Interface" do

  let!(:owner1){FactoryGirl.create(:user, :name => "Joe", :admin => false)}
  let!(:rater1){FactoryGirl.create(:user, :name => "Jack", :admin => false)}
  let!(:user1){FactoryGirl.create(:user, :name => "Dave", :username => 'dave123', :admin => false)}
  let!(:cuisine1){FactoryGirl.create(:cuisine, :name => "Korean")}
    
  before(:each) do
    visit home_path
  end  
    
  context "Initial Page" do
    scenario "Has Name of Site in Jumbotron" do
      within(:css, "div.jumbotron_search") do
        expect(page.find('h1')).to have_content('Fudz Finder')
      end
    end
  end  
    
  context "Restaurants" do  
    context "No Restaurants Available" do
      scenario "Displays No Restaurants Available" do
        expect(page).to have_content("No Restaurants available")
      end
    end  
  
    context "Restaurants Available" do
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
        expect(page.has_css?('div#reviews_area')).to be true
      end
    end
  end
  
  context "Cuisines" do
    let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "Some Restaurant", :user_id => owner1.id, :status => 'Accepted')}
    let!(:food1){FactoryGirl.create(:food, :name => "Sisig", :cuisine_id => cuisine1.id, :restaurant_id => restaurant1.id)}
    let!(:location1){FactoryGirl.create(:location, :address => "Makati", :restaurant => restaurant1)}
    
    before(:each) do
      visit home_path
    end
    
    scenario "Display Most Popular Cuisines" do
      within(:css, "div#cuisines") do
        expect(find("header h3")).to have_content("#{cuisine1.name}")
      end
    end
    
    scenario "Display Restaurant with Cuisine in Search Page" do
      within(:css, "div#cuisines") do
        find('a').click
      end
      within(:css, ".restos") do
        expect(find('.list-group-item-heading')).to have_content("#{restaurant1.name}")
      end
    end
  end
  
  context "Reviews" do
    let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "Some Restaurant", :user_id => owner1.id, :status => 'Accepted')}
    let!(:rating1){FactoryGirl.create(:rating, :restaurant_id => restaurant1.id, :user_id => rater1.id, :comment => "Testing this", :rate => 3)}
    let!(:location1){FactoryGirl.create(:location, :address => "Makati", :restaurant => restaurant1)}
    
    before(:each) do
      visit home_path
    end
    
    scenario "Display Most Recent Reviews" do
      within(:css, "div#reviews") do
        expect(find(".media-heading")).to have_content("#{restaurant1.name}")
      end
    end
    
    scenario "Display Restaurant Profile with Review" do
      within(:css, "#reviews") do
        within(:css, ".row") do
          find('a').click
        end
      end
      
      expect(page.has_css?('.social-share-button')).to be true
      expect(page.has_css?('.module')).to be true
      expect(page.has_css?('div#picture-part')).to be true
      expect(page.has_css?('div#reviews_area')).to be true
      
      within(:css, "div.col-md-9.col-sm-12.col-xs-12") do
        expect(find('div:nth-child(2) > p:nth-child(1)')).to have_content("#{restaurant1.name}")
      end  
    end
  end
  
  context "Navigation" do
    context "About" do
      scenario "displays about page" do
        click_link("About Us")
        expect(page).to have_content("About Developers")
      end
    end
  
    context "Contact" do
      scenario "displays contact page" do
        click_link("Contact Us")
        expect(page).to have_content("Contact Us")
      end
    end
  
    context "Make a Resto" do
      scenario "display login page" do
        within(:css, '#footer') do
          click_link "Make a Resto"
        end
        expect(page).to have_content("Login")
        expect(page).to have_content("Sign Up")
        expect(page).to have_content("Login with Facebook")
      end
    end
  
    context "Sign Up Today" do
       scenario "display login page" do
        click_link("Sign up today")
        expect(page).to have_content("Login")
        expect(page).to have_content("Sign Up")
        expect(page).to have_content("Login with Facebook")
       end
    end
  
    context "All Cuisines" do
      let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "Some Restaurant", :user_id => owner1.id, :status => 'Accepted')}
      let!(:food1){FactoryGirl.create(:food, :name => "Sisig", :cuisine_id => cuisine1.id, :restaurant_id => restaurant1.id)}
      let!(:location1){FactoryGirl.create(:location, :address => "Makati", :restaurant => restaurant1)}
      
      before(:each) do
        click_link("All Cuisines")
      end
      
      scenario "display cuisine list page" do
        expect(page).to have_content("#{cuisine1.name}")
        expect(page).to have_content("Explore all the cuisines")
      end
    
      scenario "Display Restaurant with Cuisine in Search Page" do
        within(:css, "#cuisines > div") do
          first('a').click
        end
        within(:css, ".restos") do
          expect(find('.list-group-item-heading')).to have_content("#{restaurant1.name}")
        end
      end
    end
  
    context "Restaurants" do
      let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "Some Restaurant", :user_id => owner1.id, :status => 'Accepted')}
      let!(:location1){FactoryGirl.create(:location, :address => "Makati", :restaurant => restaurant1)}
      
      before(:each) do
        within(:css, '.navbar-right') do
          click_link 'Restaurants'
        end
      end
      
      scenario "Display All Restaurants" do
        within(:css, ".restos") do
          expect(find('.list-group-item-heading')).to have_content("#{restaurant1.name}")
        end
      end
    end
  end
  
  # context "Search" do
  #   let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "Some Restaurant", :user_id => owner1.id, :status => 'Accepted')}
  #   let!(:restaurant2){FactoryGirl.create(:restaurant, :name => "Another Restaurant", :user_id => owner1.id, :status => 'Accepted')}
  #   let!(:food1){FactoryGirl.create(:food, :name => "Sisig", :cuisine_id => cuisine1.id, :restaurant_id => restaurant1.id)}
  #   let!(:food2){FactoryGirl.create(:food, :name => "Sisig", :cuisine_id => cuisine1.id, :restaurant_id => restaurant2.id)}
  #   let!(:location1){FactoryGirl.create(:location, :address => "Makati", :restaurant => restaurant1)}
  #   let!(:location2){FactoryGirl.create(:location, :address => "Manila", :restaurant => restaurant2)}
  #
  #   before(:each) do
  #     visit home_path
  #     fill_in 'Search for fudz/cuisine/dishes...', with: "Sisig"
  #     click_button "Search"
  #   end
  #
  #   scenario "Displays restaurants with food sisig", js: true do
  #     within(:css, ".restos") do
  #       sleep 10
  #
  #
  #       expect(first('.list-group-item-heading')).to have_content("#{restaurant1.name}")
  #     end
  #   end
  # end
  
  context "Language" do
    scenario "changes the language to russian", js: true do
      #sleep 10
      click_button "dropdownMenu2"
      within(:css, 'dropdown-menu') do
        find("li:nth-child(2) > a").click
      end
      expect(page).to have_content("Около")
    #  expect(page).to have_css('#dropdownMenu2')
    #   page.evaluate_script('$("#dropdownMenu2").trigger("click")')
    #   sleep 10
    #  find_button('#dropdownMenu2').click
      # within(:css, '.dropup') do
      #   find_button('#dropdownMenu2').click
      # end
 #     expect(page).to have_xpath('//*[@id="footer"]/div[1]/div/div[6]/div/ul/li[2]/a')
 #     find('#footer > div.container > div > div.col-lg-1.col-md-1.col-xs-12.col-sm-6 > div > ul > li:nth-child(2) > a').click
 #     expect(page).to have_content("Около")
    end
    #footer > div > div > div:nth-child(4) > div.footer_body > div > ul > li:nth-child(2) > a
    #footer > div.container > div > div.col-lg-1.col-md-1.col-xs-12.col-sm-6 > div > ul > li:nth-child(1) > a
  end

  context "Logged in" do
    before(:each) do
      within(:css, '.navbar-right') do
        click_link "Login"
      end
      fill_in 'Username', :with => user1.username
      fill_in 'password', :with => user1.password
      click_button('Login')
    end
    
    context "Make a Resto" do
      scenario "displays create restaurant page" do
        within(:css, '#footer') do
          click_link "Make a Resto"
        end
        expect(page).to have_content("Enter your restaurant's information")
      end
    end
  end
  
end