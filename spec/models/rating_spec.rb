require 'rails_helper'

RSpec.describe Rating, type: :model do

  it { is_expected.to belong_to :restaurant}
  it { is_expected.to belong_to :user}
  
  it { is_expected.to validate_presence_of :rate }
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :restaurant }
  
  let!(:user1){FactoryGirl.create(:user, :admin => false, :name => 'Joelle')}
  let!(:user2){FactoryGirl.create(:user, :admin => false)}
  let!(:user3){FactoryGirl.create(:user, :admin => false, :name => 'Fredrickson')}
  let!(:restaurant1){FactoryGirl.create(:restaurant, :status => 'Accepted', :name => 'RestoHouse', :user_id => user2.id)}
  let!(:restaurant2){FactoryGirl.create(:restaurant, :status => 'Accepted', :name => 'AnotherResto', :user_id => user2.id)}
  let!(:restaurant3){FactoryGirl.create(:restaurant, :status => 'Accepted', :name => 'YetAnotherOne', :user_id => user2.id)}
    
  let!(:rating1){FactoryGirl.create(:rating, :rate => 3, :user_id => user1.id, :restaurant_id => restaurant1.id)}
  let!(:rating2){FactoryGirl.create(:rating, :rate => 2, :user_id => user3.id, :restaurant_id => restaurant2.id)}
  let!(:rating3){FactoryGirl.create(:rating, :rate => 5, :user_id => user1.id, :restaurant_id => restaurant3.id)}
  
  it "should sort the ratings in terms of rating" do
    ratings, order = Rating.sort('Rating', ['DESC', 'ASC', 'ASC'])
    expect(ratings.first.rate).to eq(5)
    expect(order[0]).to eq('ASC')
  end
  
  it "should sort the ratings in terms of restaurant" do
    ratings, order = Rating.sort('Restaurant', ['DESC', 'ASC', 'ASC'])
    expect(ratings.first.rate).to eq(2)
    expect(ratings.first.restaurant.name).to eq('AnotherResto')
    expect(order[1]).to eq('DESC')
  end
  
  it "should sort the ratings in terms of user" do
    ratings, order = Rating.sort('User', ['DESC', 'ASC', 'ASC'])
    expect(ratings.first.rate).to eq(2)
    expect(order[2]).to eq('DESC')
  end
end
