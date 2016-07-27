require "rails_helper"
require "spec_helper"
require "capybara/rspec"

feature "User Interface" do
  let!(:owner1){FactoryGirl.create(:user, :name => "Joellee", :admin => false)}
  let!(:cuisine1){FactoryGirl.create(:cuisine, :name => "Korean")}
  let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "Some Restaurant", :user_id => owner1.id, :status => 'Accepted')}
  let!(:location1){FactoryGirl.create(:location, :address => "Makati", :restaurant => restaurant1)}
  let!(:user1){FactoryGirl.create(:user, :name => "Fredrickson", :admin => false)}
  let!(:picture1){FactoryGirl.create(:picture, :restaurant => restaurant1, :user => user1, :pic => File.open("#{Rails.root}/spec/support/sisig.jpg"))}
  
  before(:each) do
    visit home_path
    within(:css, '.navbar-right') do
      find_link("Login").click
    end
    fill_in 'Username', :with => owner1.username
    fill_in 'password', :with => owner1.password
    find_button('Login').click
  end
  
  context "Owner Interface" do
    before(:each) do
      sleep 6
      find_link("#{owner1.name}").click
      find_link("My Restaurants").click
    end
    
    context "Messages" do
      before(:each) do
        find_link("Messages").click
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
      
      context "User Uploaded Photos", js: true do
        before(:each) do
          within(:css, "#user-tabs") do
            expect(page).to have_css("a[data-target='#photo']", wait: 10)
            find(:css, "a[data-target='#photo']").click
          end
        end

        scenario "Accept User Photo" do
          within(:css, ".pending_pic") do
            find_button("Accept").click
          end
          expect(Picture.last.status).to be true
        end

        scenario "Reject User Photo" do
          id = Picture.last.id
          within(:css, ".pending_pic") do
            find_button("Reject").click
          end
          expect(Picture.exists?(id)).to be false
        end
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
          fill_in "restaurant_contact", with: "412-1231"
          find_button("Update Restaurant").click
          expect(find("#restaurant_contact").value).to eq("412-1231")
        end
      end
      
      context "Announcements", js: true do
        before(:each) do
          within(:css, "#user-tabs") do
            expect(page).to have_css("a[data-target='#announcement']", wait: 10)
            find(:css, "a[data-target='#announcement']", wait: 10).click
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
            find_link("Add Posts").click
            expect(page).to have_css("#post_comment", wait: 10, visible: false)
            find("#post_comment", wait: 10, visible: false).set("THIS IS SOME RANDOM POST")
            find_button("Create Post", wait: 10, visible: false).click
            page.evaluate_script 'window.location.reload()'
          end
          
          scenario "Add post", js: true do
            expect(page).to have_css("table")
            expect(page).to have_content(Post.last.comment)
          end
        
          scenario "Edit post", js: true do
            find_link("Edit").click
            expect(page).to have_css("#post_comment", wait: 10, visible: false)
            find("#post_comment", wait: 10, visible: false).set("THIS IS NOT SOME RANDOM POST")
            find_button("Edit Post / Announcement", wait: 10, visible: false).click
            page.evaluate_script 'window.location.reload()'
            expect(page).to have_css("table")
            expect(page).to have_content(Post.last.comment)
          end
        
          scenario "Delete post", js: true do
            find_link("Delete").click
            page.accept_confirm
            sleep 1
            page.evaluate_script 'window.location.reload()'
            
            expect(page).to have_content("No posts / announcements")
            expect(page).not_to have_css("table")
          end
        end
        
      end
      
      context "Schedules" do
        before(:each) do
          within(:css, "#user-tabs") do
            expect(page).to have_css("a[data-target='#schedule']", wait: 10)
            find(:css, "a[data-target='#schedule']", wait: 10).click
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
            find_link("Add Schedule").click
            expect(page).to have_css("#schedule_day", wait: 10, visible: false)
         #   sleep 5
            find('#schedule_day', visible: false, wait: 10).find(:xpath, "option[2]").select_option
            sleep 3
            find("#schedule_opening", visible: false, wait: 10).set("7:00 AM")
            find("#schedule_closing", visible: false, wait: 10).set("10:00 AM")
            find_button("Submit Schedule", visible: false, wait: 10).click
            page.evaluate_script 'window.location.reload()'
          end
          
          scenario "Add Schedule" do
            expect(page).to have_content("Sunday")
            expect(page).to have_content("7:00 AM")
            expect(page).to have_content("10:00 AM")
          end
          
          scenario "Edit Schedule" do
            find_link("Edit").click
            expect(page).to have_css("#schedule_day", wait: 10, visible: false)
            find('#schedule_day', visible: false, wait: 10).find(:xpath, "option[2]").select_option
            sleep 3
            find("#schedule_opening", visible: false, wait: 10).set("8:00 AM")
            find("#schedule_closing", visible: false, wait: 10).set("10:00 AM")
            find_button("Edit Schedule", visible: false, wait: 10).click
            page.evaluate_script 'window.location.reload()'

            expect(page).to have_content("Monday")
            expect(page).not_to have_content("7:00 AM")
            expect(page).to have_content("8:00 AM")
            expect(page).to have_content("10:00 AM")
          end
        
          scenario "Delete Schedule" do
            find_link("Delete").click
            page.accept_confirm
            sleep 1
            page.evaluate_script 'window.location.reload()'
            
            expect(page).to have_content("No schedules found. Enter schedules so that users can know if your store is open in a particular day")
            expect(page).not_to have_css("table")
          end
        end
        
      end
      
      context "Dishes" do
        before(:each) do
          within(:css, "#user-tabs") do
            expect(page).to have_css("a[data-target='#dish']", wait: 10)
            find(:css, "a[data-target='#dish']", wait: 10).click
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
            find_link("Add Dish").click
            expect(page).to have_css("#food_name", wait: 10, visible: false)
            sleep 5
            find('#food_name', wait: 10, visible: false).set("My Food")
            find("#food_description", wait: 10, visible: false).set("Random Description")
            find("#food_price", wait: 10, visible: false).set(24)
            find('#food_cuisine_id', wait: 10, visible: false).find(:xpath, "option[2]").select_option
            find_button("Submit Dish", visible: false, wait: 10).click
            page.evaluate_script 'window.location.reload()'
          end
          
          scenario "Add Dish" do
            food = Food.last
            expect(page).to have_content("#{food.name}")
            expect(page).to have_content("#{food.description}")
            expect(page).to have_content("#{food.price}")
            expect(page).to have_content("#{food.cuisine.name}")
          end
          
          scenario "Edit Dish" do
            find_link("Edit").click
            expect(page).to have_css("#food_name", wait: 10, visible: false)
            find('#food_name', wait: 10, visible: false).set("My Food")
            find("#food_description", wait: 10, visible: false).set("Changed Description")
            find("#food_price", wait: 10, visible: false).set(24)
            find('#food_cuisine_id', wait: 10, visible: false).find(:xpath, "option[2]").select_option
            find_button("Edit Dish", visible: false, wait: 10).click
            page.evaluate_script 'window.location.reload()'
            sleep 1
            food = Food.last
            expect(page).to have_content("#{food.name}")
            expect(page).to have_content("#{food.description}")
            expect(page).to have_content("#{food.price}")
            expect(page).to have_content("#{food.cuisine.name}")
          end
        
          scenario "Delete Dish" do
            find_link("Delete").click
            page.accept_confirm
            sleep 1
            page.evaluate_script 'window.location.reload()'
            expect(page).to have_content("No foods found. Enter dishes to your restaurant so that it can be searched through advance search")
            expect(page).not_to have_css("table")
          end
        end
      end
      
      context "Photos" do
        before(:each) do
          within(:css, "#user-tabs") do
            #picture_pic
            expect(page).to have_css("a[data-target='#photo']", wait: 10)
            find(:css, "a[data-target='#photo']", wait: 10).click
          end
        end
       
        context "Photo Operations", js: true do
          before(:each) do
            attach_file("picture_pic", "#{Rails.root}/spec/support/sisig.jpg", visible: false)
            page.evaluate_script 'window.location.reload()'
          end
          
          scenario "Add Photo" do
              expect(Picture.count).to eq(2)
              expect(Picture.last.status).to be true
          end
          
          scenario "Delete Photo" do   
            page.evaluate_script 'window.location.reload()'
            find(:css, '#photo_area > div.row.pic-row > a > div', wait: 10).click
            expect(page).to have_css(".btn-danger", wait: 15, visible: false)
            sleep 10
            find_button("Delete", wait: 10, visible: false).click
            page.accept_confirm
            sleep 1
            page.evaluate_script 'window.location.reload()'
            expect(page).not_to have_css("table")
          end
        end  
      end
        
      context "Unhappy" do
        before(:each) do
          within(:css, "#user-tabs") do
            expect(page).to have_css("a[data-target='#unhappy']", wait: 10)
            find(:css, "a[data-target='#unhappy']", wait: 10).click
          end
        end
        
        scenario "Delete Restaurant Page" do
          expect(page).to have_content("Not Happy")
        end
        
        scenario "Delete Restaurant", js: true do
          find_button("Delete Restaurant").click
          sleep 10
          page.accept_confirm
          sleep 1
          expect(page).not_to have_content("Some Restaurant")
          expect(page.current_path).to eq(home_path)
        end
      end
    end
    
    context "Add Restaurant Page" do
      before(:each) do
        find_link("Add Restaurants").click
      end
      
      scenario "Displays Add Restaurant Page" do
        expect(page).to have_content("Create New Restaurant")
      end
      
      #keep js true here to execute script
      scenario "Add Restaurant", js: true do
        fill_in 'restaurant_name', :with => "THIS IS A RESTAURANT"
        fill_in 'restaurant_contact', :with => "321-2312"
        page.execute_script("$('#latitude').val(24.1231)")
        page.execute_script("$('#longitude').val(24.1231)")
        
        find_button("Register Restaurant").click
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