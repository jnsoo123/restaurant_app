require 'rails_helper'

RSpec.describe Cuisine, type: :model do
  it { is_expected.to have_many :foods }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :avatar }
  
  let!(:cuisine1){FactoryGirl.create(:cuisine, :name => 'Korean', :avatar => File.open("#{Rails.root}/spec/support/sisig.jpg"))}
  let!(:cuisine2){FactoryGirl.create(:cuisine, :name => 'Japanese', :avatar => File.open("#{Rails.root}/spec/support/sisig.png"))}
  let!(:cuisine3){FactoryGirl.create(:cuisine, :name => 'Thai', :avatar => File.open("#{Rails.root}/spec/support/sisig.gif"))}
  let!(:cuisine4){FactoryGirl.create(:cuisine, :name => 'Taiwanese', :avatar => File.open("#{Rails.root}/spec/support/sisig.jpeg"))}
  
  let!(:user1){FactoryGirl.create(:user, :name => 'Joelle', :admin => false)}
  let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "RestoHouse", :user => user1, :status => 'Accepted')}  
  let!(:food1){FactoryGirl.create(:food, :name => 'Bulgogi', :price => 32, :cuisine => cuisine1, :restaurant => restaurant1)}
  
  it { is_expected.to allow_value(cuisine1.avatar).for(:avatar) }
  it { is_expected.to allow_value(cuisine2.avatar).for(:avatar) }
  it { is_expected.to allow_value(cuisine3.avatar).for(:avatar) }
  it { is_expected.to allow_value(cuisine4.avatar).for(:avatar) }
  
  it "should return restaurant id with cuisine name" do
    expect(Cuisine.search_by_name('Korean')).to include(1)
  end
end
