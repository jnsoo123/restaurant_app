require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  
  let!(:user1){FactoryGirl.create(:user, :name => "Samantha", :admin => false)}
  let!(:user2){FactoryGirl.create(:user, :name => "Gregor", :admin => false)}
  context "logged in as user" do
    before(:each) do
      sign_in user1
    end
    
    context "user is not owner" do
      
      describe "get #show" do
          before(:each) do
            get :show, :id => user1.id
          end
      
          it "returns user profile page" do
            expect(response).to render_template("show")
          end
          
          it "should have a user set for show" do
            expect(assigns(:user).name).to eq("Samantha")
          end
      end
    end
    
    context "user is owner" do
      describe "get #restaurants" do
        let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "RestoHouse", :user => user1)}
        let!(:restaurant2){FactoryGirl.create(:restaurant, :name => "FailHouse", :user => user2)}
        before(:each) do
          get :restaurants
        end
        
        it "returns only the restaurant connected to user" do
          restoList = assigns(:restaurants)
          expect(restoList.count).to eq(1)
          restoList.each do |resto|
            expect(resto.name).to eq("RestoHouse")
            expect(resto.name).not_to eq("FailHouse")
          end
        end
        
        it "renders the user owner restaurant page" do
          expect(response).to render_template('owner/restaurants')
        end
      end
    end
     
  end
  
  context "logged in as admin" do
    let!(:admin1){FactoryGirl.create(:user, :admin => true)}
    
    before(:each) do
      sign_in admin1
    end
    
    describe "get #edit" do
      before(:each) do
        get :edit, :id => user1.id
      end
      
      it "renders the admin edit page" do
        expect(response).to render_template "users/admin/edit"
      end
    end
  end
  
end