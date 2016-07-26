require 'rails_helper'

RSpec.describe PicturesController, type: :controller do

  let!(:user1){FactoryGirl.create(:user, :name => "Samantha", :username => "sam123", :admin => false)}
  let!(:user2){FactoryGirl.create(:user, :name => "Gregor", :username => "greg123", :admin => false)}
 
  let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "Resto", :status => "Accepted", :user => user1)}
 
  before(:each) do
    sign_in user2
  end

  context "user logged in" do
    
    describe "post #create" do
      context "Successful Create" do  
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
      
        it "needs to be approved by owner" do
          expect(Picture.last.status).to be false
        end
      end
    
      context "Failed Create" do
        before(:each) do
          post :create, :picture =>  FactoryGirl.attributes_for(:picture, :restaurant_id => restaurant1.id,
          :pic => fixture_file_upload('sisig.oa', 'image/oa'))
        end
        
        it "redirects to restaurant profile page" do
          expect(response).to redirect_to(restaurant_path(restaurant1.id))
        end
        
        it "does not add entry to pictures table" do
          expect(Picture.count).to eq(0)
        end
      end
    end  
    
    describe "get#show" do
      before(:each) do
        post :create, :picture =>  FactoryGirl.attributes_for(:picture, :restaurant_id => restaurant1.id,
        :pic => fixture_file_upload('sisig.jpg', 'image/jpg'))
        
        @picture = Picture.last
        
        xhr :get, :show, :id => @picture.id
      end
      
      it "renders show template" do
        expect(response).to render_template('show')
      end
    end
  end
  
  context "owner logged in" do
    before(:each) do
      sign_in user1
    end
    
    context "Successful create" do
      describe "post #create" do
        before(:each) do
          post :create, :picture =>  FactoryGirl.attributes_for(:picture, :restaurant_id => restaurant1.id,
          :pic => fixture_file_upload('sisig.jpg', 'image/jpg'), :user_id => user1.id)
        end
      
        it "creates a new picture entry" do
          expect(Picture.find_by(restaurant: restaurant1).pic.url).to eq('/uploads/picture/pic/1/sisig.jpg')
        end
      
        it "increases picture count by 1" do
          expect(Picture.count).to eq(1)
        end
      
        it "is an approved picture" do
          expect(Picture.last.status).to be true
        end
      end
    end
    
    context "Failed Create" do
      describe "post #create" do
        before(:each) do
          post :create, :picture =>  FactoryGirl.attributes_for(:picture, :restaurant_id => restaurant1.id,
          :pic => fixture_file_upload('sisig.oa', 'image/oa'), :user_id => user1.id)
        end
        
        it "redirects to restaurant profile page" do
          expect(response).to redirect_to(owner_resto_edit_path(restaurant1.id))
        end
        
        it "does not add entry to pictures table" do
          expect(Picture.count).to eq(0)
        end
      end
    end
    
    describe "put#update" do
      before(:each) do
        post :create, :picture =>  FactoryGirl.attributes_for(:picture, :restaurant_id => restaurant1.id,
        :pic => fixture_file_upload('sisig.jpg', 'image/jpg'), :user_id => user2.id)
        
        @picture1 = Picture.last
        
        put :update, :id => @picture1.id, :picture =>  FactoryGirl.attributes_for(:picture, :restaurant_id => restaurant1.id,
        :pic => fixture_file_upload('sisig.jpg', 'image/jpg'), :status => true)
        @picture1.reload
      end
      
      it "is approved by the owner" do
        expect(@picture1.status).to be true
      end
    end
    
    describe "delete#destroy" do
      before(:each) do
        post :create, :picture =>  FactoryGirl.attributes_for(:picture, :restaurant_id => restaurant1.id,
        :pic => fixture_file_upload('sisig.jpg', 'image/jpg'), :user_id => user2.id)
        
        @picture1 = Picture.last
        delete :destroy, :id => @picture1.id
      end
      
      it "is deleted by the owner" do
        expect(Picture.exists?(@picture1.id)).to be false
      end
      
      it "sets the success flash" do
        expect(flash[:success]).to match(/Image was deleted/)
      end
    end
    
  end
 
 
end