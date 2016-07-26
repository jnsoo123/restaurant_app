require 'rails_helper'

RSpec.describe Location, type: :model do
  it {is_expected.to belong_to :restaurant}
  
  let!(:user1){FactoryGirl.create(:user, :admin => false, :name => 'Fredrickson')}
  let!(:restaurant1){FactoryGirl.create(:restaurant, :status => 'Accepted', :name => 'RestoHouse', :user_id => user1.id)}
  let!(:location1){FactoryGirl.create(:location, :restaurant_id => restaurant1.id)}
  
  it "should have an address" do
    expect(location1.have_address?).to be true
  end
end
