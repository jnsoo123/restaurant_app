require "rails_helper"
require "spec_helper"
require "capybara/rspec"

feature "Home Interface" do

  let!(:owner1){FactoryGirl.create(:user, :name => "Joelle", :admin => false)}
  let!(:rater1){FactoryGirl.create(:user, :name => "Jacklee", :admin => false)}
  let!(:user1){FactoryGirl.create(:user, :name => "Daveras", :username => 'dave123', :admin => false)}
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
        expect(page).to have_content("No top restaurants yet.")
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
      
      scenario "Display New Restaurant" do
        within(:css, "div#new_restaurants") do
          expect(page).to have_content("#{restaurant1.name}")
        end
      end
    
      scenario "Display Restaurant Profile of Top Rated Restaurant", js: true do
        within(:css, "div#restaurants") do
            first('.hvr-bob > a').click
        end
        
        expect(page.has_css?('.module', wait: 10)).to be true
        expect(page.has_css?('div#picture-part', wait: 10)).to be true
        expect(page.has_css?('div#reviews_area', wait: 10)).to be true
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
      
      expect(page.has_css?('.module')).to be true
      expect(page.has_css?('div#picture-part')).to be true
      expect(page.has_css?('div#reviews_area')).to be true
      
      within(:css, "div.col-md-9.col-sm-12.col-xs-12") do
        expect(find('div:nth-child(1) > div.pull-left')).to have_content("#{restaurant1.name}")
      end  
    end
  end
  
  context "Navigation" do
    context "About" do
      scenario "displays about page" do
        find_link("About Us").click
        expect(page).to have_content("About Developers")
      end
    end
  
    context "Contact" do
      scenario "displays contact page" do
        find_link("Contact Us").click
        expect(page).to have_content("Contact Us")
      end
    end
  
    context "Make a Resto" do
      scenario "display login page" do
        within(:css, '#footer') do
          find_link("Make a Resto").click
        end
        expect(page).to have_content("Login")
        expect(page).to have_content("Sign Up")
        expect(page).to have_content("Login with Facebook")
      end
    end
  
    context "Sign Up Today" do
       scenario "display login page" do
        find_link("Sign up today").click
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
        find_link("All Cuisines").click
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
          find_link('Restaurants').click
        end
      end
      
      scenario "Display All Restaurants" do
        within(:css, ".restos") do
          expect(find('.list-group-item-heading')).to have_content("#{restaurant1.name}")
        end
      end
    end
  end
  
  context "Search"  do
    let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "Some Restaurant", :user_id => owner1.id, :status => 'Accepted')}
    let!(:restaurant2){FactoryGirl.create(:restaurant, :name => "Another Restaurant", :user_id => owner1.id, :status => 'Accepted')}
    let!(:food1){FactoryGirl.create(:food, :name => "Sisig", :cuisine_id => cuisine1.id, :restaurant_id => restaurant1.id, :price => 30)}
    let!(:food2){FactoryGirl.create(:food, :name => "Sisig", :cuisine_id => cuisine1.id, :restaurant_id => restaurant2.id, :price => 40)}
    let!(:location1){FactoryGirl.create(:location, :address => "Makati", :restaurant => restaurant1)}
    let!(:location2){FactoryGirl.create(:location, :address => "Manila", :restaurant => restaurant2)}
    
    let!(:location3){FactoryGirl.create(:location, :address => "Makati")}
    let!(:location4){FactoryGirl.create(:location, :address => "Manila")}

    before(:each) do
      visit home_path
      fill_in 'Search for fudz/cuisine/dishes...', with: "Sisig"
    end

    context "Search without options" do
      before(:each) do
        find(:xpath, '//*[@id="search_form"]/div/span/input').click
      end

      scenario "Displays restaurants with food sisig default order by rating" do
        expect(find(:xpath, '//*[@id="wrap"]/div[1]/div[2]/div/div[2]/div[2]/div[1]/a/div/div[2]/div/h4')).to have_content("#{restaurant1.name}")
        expect(find(:xpath, '//*[@id="wrap"]/div[1]/div[2]/div/div[2]/div[2]/div[2]/a/div/div[2]/div/h4')).to have_content("#{restaurant2.name}")
      end
      
      scenario "Display restaurants by alphabetical order" do
        find(:xpath, '//*[@id="wrap"]/div[1]/div[2]/div/div[1]/div[2]/div[2]/ul/li[2]/a').click
        expect(find(:xpath, '//*[@id="wrap"]/div[1]/div[2]/div/div[2]/div[2]/div[1]/a/div/div[2]/div/h4')).to have_content("#{restaurant2.name}")
        expect(find(:xpath, '//*[@id="wrap"]/div[1]/div[2]/div/div[2]/div[2]/div[2]/a/div/div[2]/div/h4')).to have_content("#{restaurant1.name}")        
      end
      
      scenario "Display restaurants order by price low to high" do
        find(:xpath, '//*[@id="wrap"]/div[1]/div[2]/div/div[1]/div[2]/div[2]/ul/li[3]/a').click
        expect(find(:xpath, '//*[@id="wrap"]/div[1]/div[2]/div/div[2]/div[2]/div[1]/a/div/div[2]/div/h4')).to have_content("#{restaurant1.name}")
        expect(find(:xpath, '//*[@id="wrap"]/div[1]/div[2]/div/div[2]/div[2]/div[2]/a/div/div[2]/div/h4')).to have_content("#{restaurant2.name}")        
      end
      
      scenario "Display restaurants order by price high to low" do
        find(:xpath, '//*[@id="wrap"]/div[1]/div[2]/div/div[1]/div[2]/div[2]/ul/li[4]/a').click
        expect(find(:xpath, '//*[@id="wrap"]/div[1]/div[2]/div/div[2]/div[2]/div[1]/a/div/div[2]/div/h4')).to have_content("#{restaurant2.name}")
        expect(find(:xpath, '//*[@id="wrap"]/div[1]/div[2]/div/div[2]/div[2]/div[2]/a/div/div[2]/div/h4')).to have_content("#{restaurant1.name}")        
      end
    end
    
    context "Search with options", js: true do
      before(:each) do
        find(:xpath, '//*[@id="wrap"]/div[1]/div[7]/div/div/div/div/div/a').click
      end
      
      scenario "Search with place" do
        select "Makati", from: "location"
        find(:xpath, '//*[@id="filter_search_button"]').click
        expect(find(:xpath, '//*[@id="wrap"]/div[1]/div[2]/div/div[2]/div[2]/div[1]/a/div/div[2]/div/h4')).to have_content("#{restaurant1.name}")
        expect(page).not_to have_content("#{restaurant2.name}")
      end
      
      scenario "Search with cuisine" do
        select "Korean", from: "cuisine"
        find(:xpath, '//*[@id="filter_search_button"]').click
        expect(find(:xpath, '//*[@id="wrap"]/div[1]/div[2]/div/div[2]/div[2]/div[1]/a/div/div[2]/div/h4')).to have_content("#{restaurant1.name}")
        expect(find(:xpath, '//*[@id="wrap"]/div[1]/div[2]/div/div[2]/div[2]/div[1]/a/div/div[2]/div/h4')).to have_content("#{restaurant1.name}")
      end
      
      scenario "Search with price" do
        find('.slider').drag_by(10, 0)
        sleep 2
        find(:xpath, '//*[@id="filter_search_button"]').click
        expect(find(:xpath, '//*[@id="wrap"]/div[1]/div[2]/div/div[2]/div[2]/div[1]/a/div/div[2]/div/h4')).to have_content("#{restaurant1.name}")
        expect(page).not_to have_content("#{restaurant2.name}")
      end
    end
  end
  
  context "Sign Up", js: true do
    before(:each) do
      find_link("Sign up Today").click
      fill_in 'user[name]', with: "Joedasd"
      fill_in 'user[username]', with: "joe123"
      fill_in 'user[location]', with: "Quezon"
      fill_in 'user[email]', with: "test@test.com"
      fill_in 'user[password]', with: "secret"
      fill_in 'user[password_confirmation]', with: "secret"
      find_button("Sign Up").click
    end

    scenario "Logged in successfully" do
      expect(page).to have_content("#{User.last.name.upcase}")
    end

    scenario "Logged out successfully" do
      find_link(User.last.name).click
      sleep 5
      click_link('Sign Out')
      expect(page).not_to have_content(User.last.name)
    end
  end
  
  context "Language" do
    scenario "changes the language to japanese", js: true do
      #sleep 10
      find_button("dropdownMenu2").click
      find(:xpath, '//*[@id="footer"]/div/div/div[4]/div[2]/div/ul/li[2]/a').click
      expect(page).to have_content("ホーム")
    end
    #footer > div > div > div:nth-child(4) > div.footer_body > div > ul > li:nth-child(2) > a
    #footer > div.container > div > div.col-lg-1.col-md-1.col-xs-12.col-sm-6 > div > ul > li:nth-child(1) > a
  end

  context "Logged in" do
    before(:each) do
      within(:css, '.navbar-right') do
        find_link("Login").click
      end
      fill_in 'Username', :with => user1.username
      fill_in 'password', :with => user1.password
      find_button('Login').click
    end
    
    context "User Profile" do
      scenario "display user profile page" do
        find_link(user1.name).click
        sleep 2
        find_link('My Profile').click
        expect(page).to have_content("Fudline")
        expect(page).to have_content("@dave123")
      end
    end
    
    context "Make a Resto" do
      scenario "displays create restaurant page" do
        within(:css, '#footer') do
          find_link("Make a Resto").click
        end
        expect(page).to have_content("Enter your restaurant's information")
      end
    end
  end
  
end