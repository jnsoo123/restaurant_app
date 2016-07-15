require 'rails_helper'

RSpec.describe CuisinesController, type: :controller do

  let!(:admin1){FactoryGirl.create(:user, :admin => true)}

  let!(:cuisine1){FactoryGirl.create(:cuisine, :name => "Indian")}
  let!(:cuisine2){FactoryGirl.create(:cuisine, :name => "Filipino")}


  describe "GET #index" do
    before(:each) do
      get :index
    end

    it "returns a list of cuisines ordered by name" do
      cuisineList = assigns(:cuisines)
      expect(cuisineList[0].name).to eq(cuisine2.name)
      expect(cuisineList[1].name).to eq(cuisine1.name)
    end

    it "renders index template" do
      expect(response).to render_template("index")
    end
  end

end
