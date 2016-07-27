require "rails_helper"
require "spec_helper"
require "capybara/rspec"

feature "Restaurant Interface" do
  let!(:owner1){FactoryGirl.create(:user, :name => "Joelle", :admin => false)}
  let!(:cuisine1){FactoryGirl.create(:cuisine, :name => "Korean")}
  let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "Some Restaurant", :user_id => owner1.id, :status => 'Accepted')}
  let!(:location1){FactoryGirl.create(:location, :address => "Makati", :restaurant => restaurant1)}
  let!(:user1){FactoryGirl.create(:user, :name => "Fredrickson", :admin => false)}

  before(:each) do
    visit home_path
    within(:css, '.navbar-right') do
      find_link("Login").click
    end
    fill_in 'Username', :with => user1.username
    fill_in 'password', :with => user1.password
    find_button('Login').click
    visit restaurant_path(restaurant1.id)
  end

  scenario "Display Restaurant Profile Page" do
    expect(page).to have_content("#{restaurant1.name}")
    expect(page).to have_content("0 Photos")
    expect(page).to have_content("0 Reviews")
  end
  
  scenario "Add Photo", js: true do
    expect(page).to have_css('#picture_pic', visible: false, wait: 10)
    attach_file("picture_pic", "#{Rails.root}/spec/support/sisig.jpg", visible: false)
    expect(find('.alert-dismissible').text).to match(/Image was added and waiting to be approved and posted!/)
  end
  
  context "Reviewing", js: true  do
    before(:each) do
      find_button("Write a Review", wait: 10).click
      sleep 10
      find('label[for=star2]').click
      find_button("Add Review", wait: 10).click
    end
    
    scenario "Write a review" do
      expect(find('.alert-dismissible').text).to match(/You have successfully rated the restaurant/)
    end
    
    scenario "Like a Review" do
      within(:css, '#reviews_area > div:nth-child(1) > div.media-body') do
         find(:css, 'p:nth-child(4) > a:nth-child(1)').click
         sleep 10
         expect(find(:css, 'p:nth-child(4) > a:nth-child(1)', wait: 10).text).to match(/Unlike/)
      end
    end
    
    scenario "Reply to Review" do
      within(:css, '#reviews_area > div:nth-child(1) > div.media-body') do
         find(:css, 'p:nth-child(4) > a:nth-child(2)').click
         sleep 10
         
         find(:xpath, '//*[@id="reply_comment"]', wait: 10).set("Comment")
         find(:xpath, '//*[@id="reply_comment"]', wait: 10).native.send_keys(:return)
         sleep 10
         expect(find(:xpath, '//*[@id="reviews_area"]/div[3]/div[2]/p').text).to match(Reply.last.comment)
      end
    end
  end
end
