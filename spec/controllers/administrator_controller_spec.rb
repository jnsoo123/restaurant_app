require 'rails_helper'

RSpec.describe AdministratorController, type: :controller do
  
  let!(:admin1){FactoryGirl.create(:user, :admin => true)}
  let!(:user1){FactoryGirl.create(:user)}
  let!(:user2){FactoryGirl.create(:user)}
  
  context "if logged in as admin" do
    before(:each) do
      sign_in admin1
      get :index    
    end

    describe "GET #index" do
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      
      it "returns a list of users ordered by username" do
        
        usersExpect = User.order("username")
        usersList = assigns(:users)
        
        usersExpect.zip(usersList).each do |expectList, actualList|
          expect(actualList.id).to eq(expectList.id)
          expect(actualList.name).to eq(expectList.name)
          expect(actualList.username).to eq(expectList.username)
        end
      end
    end
  end
  
  context "if not logged in as admin" do
    describe "GET #index" do
      it "returns login page" do
        get :index
        expect(response).to redirect_to user_session_path
      end
    end
  end
end
