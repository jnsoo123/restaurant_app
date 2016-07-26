require 'rails_helper'

RSpec.describe Post, type: :model do
  it { is_expected.to have_many :likes }
  it { is_expected.to have_many :replies }
  it { is_expected.to belong_to :restaurant }
  
  let!(:user1){ FactoryGirl.create(:user, :name => 'Joelle', :admin => false) }
  let!(:user2){ FactoryGirl.create(:user, :name => 'Fredrickson', :admin => false) }
  let!(:restaurant1){ FactoryGirl.create(:restaurant, :name => "RestoHouse", :user => user1, :status => 'Accepted') } 
  let!(:rating1){ FactoryGirl.create(:rating, :rate => 3, :restaurant => restaurant1, :user => user2) }
  
  
  let!(:post1){ FactoryGirl.create(:post, :comment => "This is my comment", :restaurant => restaurant1) }
  let!(:like1){ FactoryGirl.create(:like, :user => user2, :rating => rating1, :post => post1) }
  
  describe "checks if user liked this post" do
    it "should return true" do
      expect(post1.user_liked?(user2)).to be true
    end
    
    it "should return false" do
      expect(post1.user_liked?(user1)).to be false
    end
  end
  
end
