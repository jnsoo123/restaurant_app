require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe "GET #index" do
    let!(:user1){FactoryGirl.create(:user, :name => "Davidlee", :admin => false)}
    let!(:cuisine1){FactoryGirl.create(:cuisine, :name => "Korean")}
    let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "RestoHouse", :user => user1, :status => 'Accepted')}
    let!(:rating1){FactoryGirl.create(:rating, :restaurant => restaurant1, :user => user1)}
    
    before(:each) do
      get :index
    end
    
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    
    it "returns all restaurants" do
      restos = assigns(:restaurants)
      restos.each { |resto| expect(resto).to eq(restaurant1)}
    end
    
    it "returns all ratings" do
      ratings = assigns(:ratings)
      ratings.each { |rating| expect(rating).to eq(rating1)}
    end
    
    it "returns all cuisines" do
      cuisines = assigns(:cuisines)
      cuisines.each { |cuisine| expect(cuisine).to eq(cuisine1)}
    end
  end
  
  describe "GET #about" do
    it "returns renders about page" do
      get :about
      expect(response).to render_template('about')
    end
  end
  
  describe "GET #contact" do
    it "returns renders about page" do
      get :contact
      expect(response).to render_template('contact')
    end
  end

end
