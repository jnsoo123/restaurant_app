require 'rails_helper'

RSpec.describe RestaurantsController, type: :controller do
  let!(:user1){FactoryGirl.create(:user, :admin => false)}
  let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "Resto", :user_id => user1.id)}
  
  let!(:restaurant2){FactoryGirl.create(:restaurant, :name => "RestoAcc", :status => "Accepted", :user_id => user1.id)}
  let!(:restaurant3){FactoryGirl.create(:restaurant, :name => "RestoRej", :status => "Rejected", :user_id => user1.id)}
  let!(:cuisine1){FactoryGirl.create(:cuisine, :name => "Filipino")}
  let!(:food1){FactoryGirl.create(:food, :name => "Sisig", :cuisine_id => cuisine1.id,
               :restaurant_id => restaurant1.id)}

  context "Logged in as user" do
    before(:each) do
      sign_in user1
    end
    
    describe "post#create" do
      before(:each) do
        post :create, :restaurant =>  FactoryGirl.attributes_for(:restaurant, :name => "New restaurant",
        :description => "New Description", :map => "mapper", :address => "address", :contact => "Contact", 
        :low_price_range => 10, :high_price_range => 20, :status => "Pending")
      end
      
      it "creates a new restaurant" do
        search = Restaurant.find_by(name: "New restaurant")
        expect(search).not_to be nil
        expect(search.name).to eq("New restaurant")
      end
    end
    
    describe "get#owner_new" do
      it "displays the new restaurant page for owner" do
        get :owner_new
        expect(response).to render_template("owner/new")
      end
    end
    
    describe "get#owner_edit" do
      it "displays the edit restaurant page for owner" do
        get :owner_edit, :id => restaurant1.id
        expect(response).to render_template("owner/edit")
      end
    end
    
    describe "get#new" do
      it "renders new page" do
        get :new
        expect(response).to render_template("new")
      end
    end
    
    describe "delete#destroy" do
      it "removes restaurant entry"
    end
    
    describe "put#update" do
      before(:each) do
        @restoAttributes = FactoryGirl.attributes_for(:restaurant, :name => "New restaurant",
        :description => "New Description", :map => "mapper", :address => "address", :contact => "Contact", 
        :low_price_range => 10, :high_price_range => 20, :status => "Pending")

        put :update, :id => restaurant2.id, :restaurant => @restoAttributes, :path => 'dashboard'
        restaurant2.reload
      end
      
      it "updates restaurant information" do
        expect(restaurant2.name).not_to eq("RestoAcc")
        expect(restaurant2.name).to eq("New restaurant")
      end
      
      it "adds success message to flash" do
        expect(flash[:success]).to match(/successfully updated/)
      end
    end
    
  end

  context "Logged in as admin" do
    let!(:admin1){FactoryGirl.create(:user, :admin => true)}
    
    before(:each) do
      sign_in admin1
    end
    
    describe "get#listing" do
      before(:each) do
        get :listing
      end
      
      it "returns list of pending restaurants" do
        restoList = assigns(:restos_pending)
        restoList.each do |resto|
              expect(resto.name).to eq(restaurant1.name)
        end
      end
      
      it "returns list of accepted restaurants" do
        restoList = assigns(:restos_accepted)
        restoList.each do |resto|
            expect(resto.name).to eq(restaurant2.name)
        end
      end
      
      it "returns list of rejected restaurants" do
        restoList = assigns(:restos_rejected)
        restoList.each do |resto|
             expect(resto.name).to eq(restaurant3.name)
        end
      end
    end
    
    describe "get#reject" do
      it "renders reject page" do
        get :reject, :id => restaurant1.id
        expect(response).to render_template("reject")
      end
    end
    
    describe "get#edit" do
      it "renders edit page" do
        get :edit, :id => restaurant1.id
        expect(response).to render_template("edit")
      end
    end
    
    describe "put#update" do
      context "rejected restaurant status" do
        before(:each) do
          @initial = Notification.count
          @restoAttributes = FactoryGirl.attributes_for(:restaurant, :name => "New restaurant",
          :description => "New Description", :map => "mapper", :address => "address", :contact => "Contact", 
          :low_price_range => 10, :high_price_range => 20, :status => "Rejected")

          put :update, :id => restaurant2.id, :restaurant => @restoAttributes
          restaurant2.reload
        end
        
        it "sends rejected email" do
          expect{UserMailer.reject_email(restaurant2.user).deliver_now}.to change{ActionMailer::Base.deliveries.count}.by(1)
        end
      
        it "adds notification to table for rejected" do
          @initial = Notification.count
          expect(@initial).to eq(1)
        end
      end
      
      context "accepted restaurant status" do
        before(:each) do
          @initial = Notification.count
          @restoAttributes = FactoryGirl.attributes_for(:restaurant, :name => "New restaurant",
          :description => "New Description", :map => "mapper", :address => "address", :contact => "Contact", 
          :low_price_range => 10, :high_price_range => 20, :status => "Accepted")

          put :update, :id => restaurant2.id, :restaurant => @restoAttributes
          restaurant2.reload
        end

        it "sends accepted email" do
          expect{UserMailer.accept_email(restaurant2.user).deliver_now}.to change{ActionMailer::Base.deliveries.count}.by(1)
        end
      
        it "adds notification to table for accepted" do
          @initial = Notification.count
          expect(@initial).to eq(1)
        end
      end
      
      it "updates restaurant information" do
        @restoAttributes = FactoryGirl.attributes_for(:restaurant, :name => "New restaurant",
        :description => "New Description", :map => "mapper", :address => "address", :contact => "Contact", 
        :low_price_range => 10, :high_price_range => 20, :status => "Pending")

        put :update, :id => restaurant2.id, :restaurant => @restoAttributes
        restaurant2.reload
        
        
        expect(restaurant2.name).not_to eq("RestoAcc")
        expect(restaurant2.name).to eq("New restaurant")
      end
    end
  end
  
  context "Not logged in users" do
    describe "get#index" do
      it "displays index page"
    end
    
    describe "get#show" do
      before(:each) do
        get :show, :id => restaurant1.id
      end
      
      it "shows the restaurant page" do
        expect(response).to render_template("show")
      end
      
      it "returns the restaurant to show" do
        expect(assigns(:restaurant).name).to eq(restaurant1.name)
      end
    end
    
    describe "get#search" do
      context "it searches for food containing name of sisig" do
        before(:each) do
          get :search, :searchQuery => "sisig"
        end
        
        it "has search query containing sisig" do
          expect(assigns(:searchQuery)).to eq("sisig")
        end
        
        it "has search result containing food sisig" do
          results = assigns(:searchResult)
          results.each do |result|
            result.each do |food|
                expect(food.name).to eq(food1.name)
            end
          end
        end
      end
      
      context "it searches for cuisine containing name of filipino" do
        before(:each) do
          get :search, :searchQuery => "filipino"
        end
        
        it "has search query containing filipino" do
          expect(assigns(:searchQuery)).to eq("filipino")
        end
        
        it "has search result containing cuisine filipino" do
          results = assigns(:searchResult)
          results.each do |result|
            result.each do |cuisine|
                expect(cuisine.name).to eq(cuisine1.name)
            end
          end
        end
      end 
      
      context "it searches for restaurant containing name of resto" do
        before(:each) do
          get :search, :searchQuery => "restoAcc"
        end
        
        it "has search query containing resto" do
          expect(assigns(:searchQuery)).to eq("restoAcc")
        end
        
        it "has search result containing restaurant restoAcc" do
          results = assigns(:searchResult)
          results.each do |result|
            result.each do |restaurant|
                expect(restaurant.name).to eq(restaurant2.name)
            end
          end
        end
      end 
    end
  end
  
end
  