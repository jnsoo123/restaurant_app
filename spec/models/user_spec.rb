require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many :restaurants }
  it { is_expected.to have_many :ratings }
  it { is_expected.to have_many :pictures }
  it { is_expected.to have_many :notifications }
  
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :username }
  it { is_expected.to validate_uniqueness_of :username }
  it { is_expected.to validate_length_of(:name).is_at_least(6) }
  
  let!(:user1){FactoryGirl.create(:user, :name => 'Joelle', :username => 'joe123', :admin => 'false')}
  let!(:notification1){FactoryGirl.create(:notification, :message => "Some message", :user => user1)}
  
  it "checks if there is notification" do
    expect(user1.check_notification).to match(/<span class='label label-danger' style='margin-left: 10px;'>New<\/span>/)
  end
  
end
