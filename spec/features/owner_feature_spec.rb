require "rails_helper"
require "spec_helper"
require "capybara/rspec"

feature "User Interface" do
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
      
      context "Announcements", js: true do
        before(:each) do
          within(:css, "#user-tabs") do
            find(:css, "a[data-target='#announcement']").click
          end
        end
        
        scenario "Display Announcement Page" do
          within(:css, '.tab-content') do
            expect(page).to have_content("Announcements / Posts")
            expect(page).to have_content("No posts / announcements")
          end
        end
        
        context "Post Operations" do
          before(:each) do
            click_link "Add Posts"
            find("#post_comment").set("THIS IS SOME RANDOM POST")
            find_button("Create Post").click
            within(:css, "#user-tabs") do
              find(:css, "a[data-target='#announcement']").click
            end
          end
          
          scenario "Add post", js: true do
            expect(page).to have_css("table")
            expect(page).to have_content("THIS IS SOME RANDOM POST")
          end
        
          scenario "Edit post", js: true do
            click_link "Edit"
            sleep 3
            find("#post_comment").set("THIS IS NOT SOME RANDOM POST")
            find_button("Edit Post / Announcement").click
            within(:css, "#user-tabs") do
              find(:css, "a[data-target='#announcement']").click
            end
            expect(page).to have_css("table")
            expect(page).to have_content("THIS IS NOT SOME RANDOM POST")
          end
        
          scenario "Delete post", js: true do
            click_link "Delete"
            page.accept_confirm
            sleep 1
            expect(page).to have_content("No posts / announcements")
            expect(page).not_to have_css("table")
          end
        end
        
      end
      
      context "Schedules" do
        before(:each) do
          within(:css, "#user-tabs") do
            find(:css, "a[data-target='#schedule']").click
          end
        end
        
        scenario "Display Schedules Page" do
          within(:css, '.tab-content') do
            expect(page).to have_content("Schedules")
            expect(page).to have_content("No schedules found. Enter schedules so that users can know if your store is open in a particular day")
          end
        end
       
        context "Schedule Operations", js: true do
          before(:each) do
            click_link "Add Schedule"
            find('#schedule_day').find(:xpath, "option[2]").select_option
            find("#schedule_opening").set("7:00 AM")
            find("#schedule_closing").set("10:00 AM")
            find_button("Submit Schedule").click
            within(:css, "#user-tabs") do
              find(:css, "a[data-target='#schedule']").click
            end
          end
          
          scenario "Add Schedule" do
            expect(page).to have_content("Sunday")
            expect(page).to have_content("7:00 AM")
            expect(page).to have_content("10:00 AM")
          end
          
          scenario "Edit Schedule" do
            click_link "Edit"
            sleep 3
            find('#schedule_day').find(:xpath, "option[2]").select_option
            find("#schedule_opening").set("8:00 AM")
            find("#schedule_closing").set("10:00 AM")
            find_button("Edit Schedule").click
            
            within(:css, "#user-tabs") do
              find(:css, "a[data-target='#schedule']").click
            end
            expect(page).to have_content("Monday")
            expect(page).not_to have_content("7:00 AM")
            expect(page).to have_content("8:00 AM")
            expect(page).to have_content("10:00 AM")
          end
        
          scenario "Delete Schedule" do
            click_link "Delete"
            page.accept_confirm
            sleep 1
            expect(page).to have_content("No schedules found. Enter schedules so that users can know if your store is open in a particular day")
            expect(page).not_to have_css("table")
          end
        end
        
      end
      
      context "Dishes" do
        before(:each) do
          within(:css, "#user-tabs") do
            find(:css, "a[data-target='#dish']").click
          end
        end
        
        scenario "Display Dishes Page" do
          within(:css, '.tab-content') do
            expect(page).to have_content("Dishes")
            expect(page).to have_content("No foods found. Enter dishes to your restaurant so that it can be searched through advance search")
          end
        end
       
        context "Dish Operations", js: true do
          before(:each) do
            click_link "Add Dish"
            sleep 3
            find('#food_name').set("My Food")
            find("#food_description").set("Random Description")
            find("#food_price").set(24)
            find('#food_cuisine_id').find(:xpath, "option[2]").select_option
            find_button("Submit Dish").click
            within(:css, "#user-tabs") do
              find(:css, "a[data-target='#dish']").click
            end
          end
          
          scenario "Add Dish" do
            expect(page).to have_content("My Food")
            expect(page).to have_content("Random Description")
            expect(page).to have_content("24.0")
            expect(page).to have_content("Korean")
          end
          
          scenario "Edit Dish" do
            click_link "Edit"
            sleep 3
            find('#food_name').set("My Food")
            find("#food_description").set("Changed Description")
            find("#food_price").set(24)
            find('#food_cuisine_id').find(:xpath, "option[2]").select_option
            find_button("Edit Dish").click
            
            within(:css, "#user-tabs") do
              find(:css, "a[data-target='#dish']").click
            end
            sleep 1
            expect(page).to have_content("My Food")
            expect(page).to have_content("Changed Description")
            expect(page).to have_content("24.0")
            expect(page).to have_content("Korean")
          end
        
          scenario "Delete Dish" do
            click_link "Delete"
            page.accept_confirm
            sleep 1
            expect(page).to have_content("No foods found. Enter dishes to your restaurant so that it can be searched through advance search")
            expect(page).not_to have_css("table")
          end
        end
      end
      
      context "Photos" do
        before(:each) do
          within(:css, "#user-tabs") do
            find(:css, "a[data-target='#photo']").click
          end
        end
        
        scenario "Display Photos Page" do
          within(:css, '.tab-content') do
            expect(page).to have_content("Dishes")
            expect(page).to have_content("No Dishes.")
          end
        end
        
        # context "User Uploaded Photos", js: true do
        #   before(:each) do
        #     FactoryGirl.create(:picture, :restaurant => restaurant1, :user => user1, :pic => File.open("#{Rails.root}/spec/support/sisig.jpg"))
        #     sleep 3
        #     click_link "Edit Information"
        #     sleep 3
        #     click_link "Photos"
        #   end
        #
        #   scenario "Accept User Photo" do
        #     puts "THIS IS THE PICTURE COUNT: #{Picture.last.inspect}"
        #     within(:css, "#photo > div.row.thumbnail_panel.pending_pic") do
        #       click_button("Accept")
        #     end
        #     sleep 1
        #     expect(Picture.last.status).to be true
        #   end
        #
        #   scenario "Reject User Photo" do
        #     id = Picture.last.id
        #     within(:css, ".pending_pic") do
        #       click_button("Reject")
        #     end
        #     expect(Picture.exists?(id)).to be false
        #   end
        # end
       
        context "Photo Operations", js: true do
          before(:each) do
            attach_file("picture_pic", "#{Rails.root}/spec/support/sisig.jpg", visible: false)
            within(:css, "#user-tabs") do
              find(:css, "a[data-target='#photo']").click
            end
          end
          
          scenario "Add Photo" do
            within(:css, '.tab-content') do
              expect(page).to have_css('a')
            end
          end
          
          scenario "Delete Photo" do
            find(:xpath, '//*[@id="photo"]/div[1]/div[2]/a/div').click
            sleep 5
            find_button("Delete").click
            page.accept_confirm
            sleep 1
            within(:css, "#user-tabs") do
              find(:css, "a[data-target='#photo']").click
            end
            expect(page).to have_content("No Photos.")
            expect(page).not_to have_css("table")
          end
        end  
      end
        
      context "Unhappy" do
        before(:each) do
          within(:css, "#user-tabs") do
            find(:css, "a[data-target='#unhappy']").click
          end
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