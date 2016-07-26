require 'rails_helper'

RSpec.describe Food, type: :model do
  
  let!(:cuisine1){FactoryGirl.create(:cuisine, :name => 'Korean')}
  let!(:user1){FactoryGirl.create(:user, :name => 'Joelle', :admin => false)}
  let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "RestoHouse", :user => user1)}  
  let!(:food1){FactoryGirl.create(:food, :name => 'Bulgogi', :price => 32, :cuisine => cuisine1, :restaurant => restaurant1)}
  let!(:food2){FactoryGirl.create(:food, :name => 'Kimchi', :price => 10, :cuisine => cuisine1, :restaurant => restaurant1)}
  
  it { is_expected.to belong_to :cuisine }
  it { is_expected.to belong_to :restaurant }
  
  it { is_expected.to validate_presence_of :name}
  it { is_expected.to validate_presence_of :price}
  it { is_expected.to validate_presence_of :cuisine}
  it { is_expected.to validate_numericality_of(:price).is_greater_than(0)}
  
  it "should return restaurant that has the food" do
    expect(Food.search_by_name('Bulgogi')).to include(1)
  end
  
  it "should return min price" do
    expect(Food.min).to eq(10)
  end
  
  it "should return max price" do
    expect(Food.max).to eq(32)
  end
  
end
