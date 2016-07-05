require 'rails_helper'

RSpec.describe FoodsController, type: :controller do
  
  
  let!(:user1){FactoryGirl.create(:user, :name => "Dave", :admin => false)}
  let!(:cuisine1){FactoryGirl.create(:cuisine, :name => "Korean")}
  
  before(:each) do
    sign_in user1
  end
  
  
  context "owner logged in" do
    let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "RestoHouse", :user => user1)}
    let!(:food1){FactoryGirl.create(:food, :name => "Random Stuff", :cuisine_id => cuisine1.id,
    :restaurant_id => restaurant1.id)}
    
    describe "get #new" do
      before(:each) do
       xhr :get, :new, :resto_id => restaurant1.id
      end
      
      it "creates a new instance of food for that restaurant" do
        food = assigns(:food)
        expect(food.restaurant).to eq(restaurant1)
        expect(food.name).to be nil
        expect(food.description).to be nil
        expect(food.price).to be nil
        expect(food.restaurant_id).not_to be nil
      end
      
      it "renders new template" do
        expect(response).to render_template('new')
      end
    end
    
    describe "get #edit" do
      before(:each) do
       xhr :get, :edit, :id => food1.id
      end
      
      it "renders edit template" do
        expect(response).to render_template('edit')
      end
      
      it "passes food entry" do
        expect(assigns(:food)).to eq(food1)
      end
    end
    
    describe "post #create" do
      before(:each) do
        xhr :post, :create, :food =>  FactoryGirl.attributes_for(:food, :name => "Bulgogi", :description => "meat",
        :price => 20, :cuisine_id => cuisine1.id, :restaurant_id => restaurant1.id), :resto_id => restaurant1.id
      end
      
      it "creates a new food" do
        expect(Food.count).to eq(2)
      end
      
      it "creates a new food with description meat" do
        expect(Food.find_by(name: "Bulgogi").description).to eq("meat")
      end
      
      it "renders owner restaurant edit page" do
        expect(response).to render_template('create')
      end
    end
    
    describe "delete #destroy" do
      before(:each) do
        @id = food1.id
        delete :destroy, :id => food1.id
      end
      
      it "removes a food entry" do
        expect(Food.exists?(@id)).to be false
      end
      
      it "food count should be 0" do
        expect(Food.count).to eq(0)
      end
    end
    
    describe "put #update" do
      before(:each) do
        @foodAttributes = FactoryGirl.attributes_for(:food, :name => "Bulgogi", :description => "meat",
        :price => 20, :cuisine_id => cuisine1.id, :restaurant_id => restaurant1.id)

        put :update, :id => food1.id, :food => @foodAttributes
        food1.reload
      end
      
      it "should update food values" do
        expect(food1.name).to eq("Bulgogi")
        expect(food1.description).to eq("meat")
        expect(food1.price).to eq(20)
        expect(food1.cuisine.name).to eq("Korean")
        expect(food1.restaurant.name).to eq("RestoHouse")
      end
    end
  end
  
  
end