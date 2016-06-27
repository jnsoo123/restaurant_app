require 'rails_helper'

RSpec.describe CuisinesController, type: :controller do

  let!(:admin1){FactoryGirl.create(:user, :admin => true)}

  let!(:cuisine1){FactoryGirl.create(:cuisine, :name => "Indian")}
  let!(:cuisine2){FactoryGirl.create(:cuisine, :name => "Filipino")}

  context "if logged in as admin" do
    before(:each) do
      sign_in admin1
    end

    describe "GET #index" do
      before(:each) do
        get :index
      end
      
      it "returns a list of cuisines ordered by most recently updated" do
        cuisineList = assigns(:cuisines)
        expect(cuisineList[0].name).to eq(cuisine2.name)
        expect(cuisineList[1].name).to eq(cuisine1.name)
      end
      
      it "renders index template" do
        expect(response).to render_template("index")
      end
    end
    
    describe "GET #new" do
      it "renders the new template" do
        get :new
        expect(response).to render_template("new")
      end
    end
    
    describe "GET #edit" do
      
      before(:each) do 
        get :edit, :id => cuisine1.id
      end
      
      it "renders the edit template" do
        expect(response).to render_template("edit")
      end
      
      it "passes the cuisine" do
        expect(assigns(:cuisine)).to eq(cuisine1)
      end
    end
    
    describe "POST #create" do
      before(:each) do
        post :create, :cuisine =>  FactoryGirl.attributes_for(:cuisine, :name => "Korean",
        :description => "New Description")
      end
      
      it "redirects to index" do
        expect(response).to redirect_to cuisines_path
      end
      
      it "creates a new cuisine" do
        cuisine = Cuisine.find_by(name: "Korean")
        expect(cuisine).not_to be nil
        expect(cuisine.name).to eq("Korean")
      end
    end
    
    describe "PUT #update" do
      before(:each) do
        @cuisineAttributes = FactoryGirl.attributes_for(:cuisine, :name => "Korean",
        :description => "New Description")

        put :update, :id => cuisine1.id, :cuisine => @cuisineAttributes
        cuisine1.reload
        
      end
      
      it "redirects to index" do
        expect(response).to redirect_to cuisines_path
      end
      
      it "updates an existing cuisine" do
        expect(cuisine1.name).not_to eq("Indian")
        expect(cuisine1.name).to eq("Korean")
      end
    end
    
    describe "DELETE #destroy" do
      before(:each) do
        @id = cuisine1.id
        delete :destroy, :id => cuisine1.id
      end
      
      it "removes a cuisine entry" do
        expect(Cuisine.exists?(@id)).to be false
      end
      
      it "redirects to index" do
        expect(response).to redirect_to cuisines_path
      end
    end
    
  end

end
