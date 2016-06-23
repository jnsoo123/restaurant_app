require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  
  let!(:user1){FactoryGirl.create(:user, :name => "Sam", :username => "sam123", :admin => false)}
  let!(:user2){FactoryGirl.create(:user, :name => "Greg", :username => "greg123", :admin => false)}
  let!(:user3){FactoryGirl.create(:user, :name => "Joe", :username => "joe123", :admin => false)}
  
  let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "Resto", :status => "Accepted", :user => user1)}
  let!(:restaurant2){FactoryGirl.create(:restaurant, :name => "AnotherResto", :status => "Accepted", :user => user2)}
  
  context "if logged in as admin" do
    let!(:admin1){FactoryGirl.create(:user, :name => 'dave', :admin => true)}
    
    before(:each) do
      sign_in admin1
    end
    
    describe "get #index" do
      let!(:rating1){FactoryGirl.create(:rating, :rate => 4, :user => user1, :restaurant => restaurant1)}
      let!(:rating2){FactoryGirl.create(:rating, :rate => 2, :user => user2, :restaurant => restaurant1)}
      let!(:rating3){FactoryGirl.create(:rating, :rate => 3, :user => user3, :restaurant => restaurant2)}
      
      context "get index without search params" do
        before(:each) do
          get :index
        end
        
        it "contains all ratings" do
          expect(assigns(:ratings)).to contain_exactly(rating1, rating2, rating3)
        end
        
        it "returns all ratings based on rate in descending order" do
          ratingList = Rating.order('rate desc')
          controllerList = assigns(:ratings)
   
          ratingList.zip(controllerList).each do |rList, cList|
            Rating.columns.each do |column|
              expect(cList.send(column.name)).to eq(rList.send(column.name))
            end
          end
        end  
      end
      
      context "get index with search params" do  
        it "returns all ratings sorted by rate" do
          get :index, :search_category => "Rating"
          
          ratingList = Rating.order('rate desc')
          controllerList = assigns(:ratings)
   
          ratingList.zip(controllerList).each do |rList, cList|
            Rating.columns.each do |column|
              expect(cList.send(column.name)).to eq(rList.send(column.name))
            end
          end
        end
      
        it "returns all ratings sorted by restaurant name" do
          get :index, :search_category => "Restaurant"
          
          ratingList = Rating.joins("LEFT JOIN restaurants on ratings.restaurant_id = restaurants.id").order('LOWER(name)')
          controllerList = assigns(:ratings)
   
          ratingList.zip(controllerList).each do |rList, cList|
            Rating.columns.each do |column|
              expect(cList.send(column.name)).to eq(rList.send(column.name))
            end
          end
        end
        
        it "returns all ratings sorted by restaurant name" do
          get :index, :search_category => "User"
          
          ratingList = Rating.joins("LEFT JOIN users on ratings.user_id = users.id").order("LOWER(name)")
          controllerList = assigns(:ratings)
   
          ratingList.zip(controllerList).each do |rList, cList|
            Rating.columns.each do |column|
              expect(cList.send(column.name)).to eq(rList.send(column.name))
            end
          end
        end
      end
    end
  end
  
  context "if logged in as user" do
    before(:each) do
      sign_in user3
    end
    
    describe "post #create" do
      before(:each) do
        @initial = Rating.count
        post :create, :rating =>  FactoryGirl.attributes_for(:rating, :rate => 5, :user => user3,
        :restaurant => restaurant2, :comment => "Message in a bottle")
      end
      
      it "creates a new rating entry" do
        expect(Rating.count).to eq(1)
        expect(Rating.find_by(user: user3).comment).to eq("Message in a bottle")
      end
    end
  end
  
  
end