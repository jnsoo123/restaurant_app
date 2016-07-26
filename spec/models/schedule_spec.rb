require 'rails_helper'

RSpec.describe Schedule, type: :model do

  let!(:user1){FactoryGirl.create(:user, :name => 'Joelle', :admin => false)}
  let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "RestoHouse", :user => user1)} 
  let!(:schedule1){FactoryGirl.create(:schedule, :day => 'Friday', :opening => "11:00 AM", :closing => "12:00 PM", :restaurant_id => restaurant1.id)}  
  let!(:schedule2){FactoryGirl.create(:schedule, :day => 'Friday', :opening => "10:00 AM", :closing => "12:00 PM", :restaurant_id => restaurant1.id)}  
  let!(:schedule3){FactoryGirl.create(:schedule, :day => 'Friday', :opening => "1:00 AM", :closing => "8:00 AM", :restaurant_id => restaurant1.id)}  

  it { is_expected.to validate_presence_of :day }
  it { is_expected.to validate_presence_of :opening }
  it { is_expected.to validate_presence_of :closing }
  it { is_expected.to validate_presence_of :restaurant }

  it {is_expected.to belong_to :restaurant}
  
  describe "check time value" do
    it "should return true since opening after closing" do
      expect(Schedule.check_time?("3:00 AM", "2:00 AM")).to be true
    end
    
    it "should return false since opening before closing" do
      expect(Schedule.check_time?("3:00 AM", "4:00 AM")).to be false
    end
  end
  
  describe "checks for overlapping values" do
    it "should return false since overlapping" do
        expect(Schedule.check_overlapping?(schedule2, restaurant1)).to be false
    end
    
    it "should return true since not overlapping" do
        expect(Schedule.check_overlapping?(schedule3, restaurant1)).to be true
    end
  end
end
