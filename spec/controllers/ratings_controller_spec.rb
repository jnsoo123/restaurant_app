require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  
  let!(:user1){FactoryGirl.create(:user, :name => "Sam", :username => "sam123", :admin => false)}
  let!(:user2){FactoryGirl.create(:user, :name => "Greg", :username => "greg123", :admin => false)}
  let!(:user3){FactoryGirl.create(:user, :name => "Joe", :username => "joe123", :admin => false)}
  
  let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "Resto", :status => "Accepted", :user => user1)}
  let!(:restaurant2){FactoryGirl.create(:restaurant, :name => "AnotherResto", :status => "Accepted", :user => user2)}
  let!(:rating2){FactoryGirl.create(:rating, :restaurant => restaurant2, :user => user3)}
  
  
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
          get :index, :search_category => "Rating", :search_order => ["DESC","ASC","ASC"]
          
          ratingList = Rating.order('rate DESC')
          controllerList = assigns(:ratings)
   
          ratingList.zip(controllerList).each do |rList, cList|
            Rating.columns.each do |column|
              expect(cList.send(column.name)).to eq(rList.send(column.name))
            end
          end
        end
      
        it "returns all ratings sorted by restaurant name" do
          get :index, :search_category => "Restaurant", :search_order => ["DESC","ASC","ASC"]
          
          ratingList = Rating.joins("LEFT JOIN restaurants on ratings.restaurant_id = restaurants.id").order('LOWER(name)')
          controllerList = assigns(:ratings)
   
          ratingList.zip(controllerList).each do |rList, cList|
            Rating.columns.each do |column|
              expect(cList.send(column.name)).to eq(rList.send(column.name))
            end
          end
        end
        
        it "returns all ratings sorted by restaurant name" do
          get :index, :search_category => "User", :search_order => ["DESC","ASC","ASC"]
          
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
        post :create, :rating =>  FactoryGirl.attributes_for(:rating, :rate => 5,
        :restaurant_id => restaurant2.id, :comment => "Message in a bottle")
      end
      
      it "creates a new rating entry" do
        expect(Rating.count).to eq(2)
        expect(Rating.where(user: user3).last.comment).to eq("Message in a bottle")
      end
    end
    
    describe "put#update" do
      before(:each) do
        post :create, :rating =>  FactoryGirl.attributes_for(:rating, :rate => 5,
        :restaurant_id => restaurant2.id, :comment => "Message in a bottle")
      
        @rating1 = Rating.find_by(comment: 'Message in a bottle')
      end
      
      context "Successful Update" do
        before(:each) do
          put :update, :id => @rating1.id ,:rating =>  FactoryGirl.attributes_for(:rating, :rate => 5,
          :restaurant_id => restaurant2.id, :comment => "Message in a jar")
          @rating1.reload
        end
      
        it "updated the message in the rating" do
          expect(@rating1.comment).to match(/Message in a jar/)
        end
      end
      
      context "Failed Update" do
        before(:each) do
          put :update, :id => @rating1.id ,:rating =>  FactoryGirl.attributes_for(:rating, :rate => "",
          :restaurant_id => restaurant2.id, :comment => "Message in a jar")
          @rating1.reload
        end
      
        it "redirect to restaurant profile page" do
          expect(response).to redirect_to(restaurant_path(restaurant2.id))
        end
      end
    end
    
    describe "get#edit" do
      before(:each) do
        xhr :get, :edit, :id => rating2.id
      end
      
      it "renders edit template" do
        expect(response).to render_template('edit')
      end
    end
  end
  
  
end