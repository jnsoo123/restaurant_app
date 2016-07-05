require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do

  let!(:owner1){FactoryGirl.create(:user, :admin => false)}
  let!(:notif1){FactoryGirl.create(:notification, :status => true, :user => owner1)}

  context "if logged in as owner" do
    before(:each) do
      sign_in owner1
    end

    describe "GET #index" do
      before(:each) do
        get :index
      end
      
      it "renders notifications template" do
        expect(response).to render_template("owner/notifications")
      end
      
      it "returns updates all notification status to true" do
        notifs = assigns(:notifications)
        notifs.each do |notif| 
          expect(notif.status).to be true
        end
      end
    end
    
    describe "DELETE #destroy" do
      before(:each) do
        @id = notif1.id
        delete :destroy, :id => notif1.id
      end
      
      it "redirects to owner/notifications" do
        expect(response).to redirect_to notifications_path
      end
      
      it "deletes notification" do
        expect(Notification.exists?(@id)).to be false
      end
    end
    
  end

end
