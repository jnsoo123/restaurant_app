require 'rails_helper'

RSpec.describe PicturesController, type: :controller do

  let!(:user1){FactoryGirl.create(:user, :name => "Sam", :username => "sam123", :admin => false)}
  let!(:user2){FactoryGirl.create(:user, :name => "Greg", :username => "greg123", :admin => false)}
 
  let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "Resto", :status => "Accepted", :user => user1)}
 
  before(:each) do
    sign_in user2
  end

  context "user logged in" do
    describe "post #create" do
      before(:each) do
        post :create, :picture =>  FactoryGirl.attributes_for(:picture, :restaurant_id => restaurant1.id,
        :pic => fixture_file_upload('sisig.jpg', 'image/jpg'))
      end
      
      it "creates a new picture entry" do
        expect(Picture.find_by(restaurant: restaurant1).pic.url).to eq('/uploads/picture/pic/1/sisig.jpg')
      end
      
      it "increases picture count by 1" do
        expect(Picture.count).to eq(1)
      end
    end
  end
 
 
end