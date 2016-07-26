require 'rails_helper'

RSpec.describe Restaurant, type: :model do

  let!(:cuisine1){FactoryGirl.create(:cuisine, :name => 'Korean')}
  
  let!(:user1){FactoryGirl.create(:user, :name => 'Joelle', :admin => false)}
  let!(:user2){FactoryGirl.create(:user, :name => 'Fredrickson', :admin => false)}
  let!(:user3){FactoryGirl.create(:user, :name => 'George', :admin => false)}
  
  let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "RestoHouse", :user => user1)}  
  
  let!(:food1){FactoryGirl.create(:food, :name => 'Bulgogi', :price => 32, :cuisine => cuisine1, :restaurant => restaurant1)}
  let!(:food2){FactoryGirl.create(:food, :name => 'Kimchi', :price => 10, :cuisine => cuisine1, :restaurant => restaurant1)}
  
  let!(:schedule1){FactoryGirl.create(:schedule, :day => 'Friday', :opening => "11:00 AM", :closing => "12:00 PM", :restaurant_id => restaurant1.id)}  

  let!(:rating1){FactoryGirl.create(:rating, :rate => 3, :user_id => user2.id, :restaurant_id => restaurant1.id)}
  let!(:rating2){FactoryGirl.create(:rating, :rate => 2, :user_id => user3.id, :restaurant_id => restaurant1.id)}

  it { is_expected.to belong_to :user }
  it { is_expected.to have_many :ratings }
  it { is_expected.to have_many :schedules }
  it { is_expected.to have_many :foods }
  it { is_expected.to have_many :pictures }
  it { is_expected.to have_many(:cuisines).through(:foods) }
  it { is_expected.to have_one(:location) }
  
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :contact }
  
  it "returns average ratings of restaurant" do
    expect(restaurant1.ave_ratings).to eq(2.5)
  end
  
  it "returns min price" do
    expect(restaurant1.min_price).to eq(10)
  end
  
  it "returns max price" do
    expect(restaurant1.max_price).to eq(32)
  end
  
  it "returns restaurant id matching name" do
    expect(Restaurant.search_by_name('RestoHouse')).to include(1)
  end
  
  it "returns status on whether resto is open or closed" do
    expect(restaurant1.is_open?(DateTime.new(2016, 7, 8, 13, 31, 0, '+8'))).to be false
    expect(restaurant1.is_open?(DateTime.new(2016, 7, 8, 11, 31, 0, '+8'))).to be true
  end
  
  it "returns schedule of restaurant" do
    restaurant1.sched { |key, value| expect(value).to include(schedule1)}
  end

end
