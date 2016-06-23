require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  
  let!(:user1){FactoryGirl.create(:user, :admin => false)}
  context "logged in as user" do
    before(:each) do
      sign_in user1
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