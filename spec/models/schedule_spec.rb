require 'rails_helper'

RSpec.describe Schedule, type: :model do

  let!(:user1){FactoryGirl.create(:user, :name => 'Joe', :admin => false)}
  let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "RestoHouse", :user => user1)} 
  let!(:schedule1){FactoryGirl.create(:schedule, :day => 'Friday', :opening => "11:00 AM", :closing => "12:00 PM", :restaurant_id => restaurant1.id)}  

  it { is_expected.to validate_presence_of :day }
  it { is_expected.to validate_presence_of :opening }
  it { is_expected.to validate_presence_of :closing }
  it { is_expected.to validate_presence_of :restaurant }

  it {is_expected.to belong_to :restaurant}
  
  describe "checks for overlapping values" do
    it "should return false since overlapping" do
        expect(Schedule.check_overlapping?(FactoryGirl.attributes_for(:schedule, :opening => '10:00 AM', 
        :closing => "12:00 PM", :day => 'Friday'), restaurant1)).to be false
    end
    
    it "should return true since not overlapping" do
        expect(Schedule.check_overlapping?(FactoryGirl.attributes_for(:schedule, :opening => '1:00 AM', 
        :closing => "8:00 AM", :day => 'Friday'), restaurant1)).to be true
    end
  end
end
