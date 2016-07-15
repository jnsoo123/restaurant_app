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
      sleep 5
      click_link "#{owner1.name}"
      click_link "My Restaurants"
    end
    
    context "Messages" do
      before(:each) do
        click_link "Messages"
      end
      
      scenario "Display Message Page" do
        expect(page.current_path).to eq(notifications_path)
      end
    
      context "No Message" do
        scenario "Display No Messages" do
          expect(page).to have_content("No messages.")
        end
      end
      
      context "Has Message" do
        let!(:notification1){FactoryGirl.create(:notification, :user => owner1, :message => "Some Message")}
        before(:each) do
          visit notifications_path
        end
        
        scenario "Display 1 Message" do
          #notification_area > div.table-responsive > table > tbody > tr > td.notification_messages
          within(:css, "tbody") do
            within(:css, "tr") do
              expect(find('td:nth-child(1)').text).to match(/Some Message/)
            end
          end
        end
        
        scenario "Empty Messages" do
          click_link "Delete"
          expect(page).to have_content("No messages.")
        end
      end
    end
    
    context "Restaurant Page" do
      before(:each) do
        find(:xpath, '//*[@id="dashboard-owner"]/div/div[2]/div/div[2]/div[1]/a').click
      end
      
      context "Edit Information" do
        scenario "Display Restaurant Edit Page" do
          within(:css, ".tab-content") do
            expect(page).to have_content("Edit Information")
            expect(page).to have_content("Edit Map Location")
          end
          expect(page.current_path == owner_resto_edit_path(restaurant1.id)).to be true
        end
      
        scenario "Edit Restaurant" do
          fill_in "restaurant_contact", with: "I changed this"
          click_button "Update Restaurant"
          expect(find("#restaurant_contact").value).to eq("I changed this")
        end
      end
      
      context "Announcements" do
        before(:each) do
          click_link "Announcements / Posts"
        end
        
        scenario "Display Announcement Page" do
          within(:css, '.tab-content') do
            expect(page).to have_content("Announcements / Posts")
            expect(page).to have_content("No Posts")
          end
        end
        
        scenario "Add post", js: true do
          click_link "Add Posts"
          find("#post_comment").set("THIS IS SOME RANDOM POST")
          find_button("Create Post").click
          expect(page).to have_css("table")
          expect(page).to have_content("THIS IS SOME RANDOM POST")
        end
        
        context "Existing Post" do
          before(:each) do
            click_link "Add Posts"
            find("#post_comment").set("THIS IS SOME RANDOM POST")
            find_button("Create Post").click
            click_link "Announcements / Posts"
          end
          
          scenario "Edit post", js: true do
            click_link "Edit"
            find("#post_comment").set("THIS IS SOME RANDOM POST")
            find_button("Edit Post / Announcement").click
            expect(page).to have_css("table")
            expect(page).to have_content("THIS IS SOME RANDOM POST")
          end
        
          scenario "Delete post", js: true do
            click_link "Delete"
            page.accept_confirm
            sleep 1
            expect(page).to have_content("No Posts")
            expect(page).not_to have_css("table")
          end
        end
        
      end
      
      context "Schedules" do
        before(:each) do
          click_link "Schedules"
        end
        
        scenario "Display Schedules Page" do
          within(:css, '.tab-content') do
            expect(page).to have_content("Schedules")
            expect(page).to have_content("No Schedule Available")
          end
        end
       
        context "Schedule Operations" do
          before(:each) do
            click_link "Add Schedule"
            find('#schedule_day').find(:xpath, "option[2]").select_option
            find("#schedule_opening").set("7:00 AM")
            find("#schedule_closing").set("10:00 AM")
            find_button("Submit Schedule").click
            click_link "Schedules"
          end
          
          scenario "Add Schedule", js: true do
            expect(page).to have_content("Sunday")
            expect(page).to have_content("7:00 AM")
            expect(page).to have_content("10:00 AM")
          end
          
          scenario "Edit Schedule", js: true do
            click_link "Edit"
            find('#schedule_day').find(:xpath, "option[2]").select_option
            find("#schedule_opening").set("8:00 AM")
            find("#schedule_closing").set("10:00 AM")
            find_button("Edit Schedule").click
            
            click_link "Schedules"
            expect(page).to have_content("Monday")
            expect(page).not_to have_content("7:00 AM")
            expect(page).to have_content("8:00 AM")
            expect(page).to have_content("10:00 AM")
          end
        
          scenario "Delete post", js: true do
            click_link "Delete"
            page.accept_confirm
            sleep 1
            expect(page).to have_content("No Schedule Available")
            expect(page).not_to have_css("table")
          end
        end
        
      end
      
      context "Dishes" do
      end
      
      context "Photos" do
      end
      
      context "Unhappy" do
        before(:each) do
          click_link "Unhappy?"
        end
        
        scenario "Delete Restaurant Page" do
          expect(page).to have_content("Not Happy")
        end
        
        scenario "Delete Restaurant", js: true do
          click_button "Delete Restaurant"
          page.accept_confirm
          sleep 1
          expect(page).not_to have_content("Some Restaurant")
          expect(page.current_path).to eq(home_path)
        end
      end
    end
    
    context "Add Restaurant Page" do
      before(:each) do
        click_link "Add Restaurants"
      end
      
      scenario "Displays Add Restaurant Page" do
        expect(page).to have_content("Create New Restaurant")
      end
      
      #keep js true here to execute script
      scenario "Add Restaurant", js: true do
        fill_in 'restaurant_name', :with => "THIS IS A RESTAURANT"
        fill_in 'restaurant_contact', :with => "THIS IS MY CONTACT"
        page.execute_script("$('#latitude').val(24.1231)")
        page.execute_script("$('#longitude').val(24.1231)")
        
        click_button "Register Restaurant"
        expect(page.current_path == users_restaurant_path).to be true
        expect(page).to have_content("THIS IS A RESTAURANT")
        expect(page).to have_content("Pending")
      end
    end

    
    scenario "Return to Home Page" do
      click_link "Go Back to Mainpage"
      expect(page.current_path == home_path).to be true
    end
  end
  
  
end