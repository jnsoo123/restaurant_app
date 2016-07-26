require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  
  let!(:user1){FactoryGirl.create(:user, :name => "Davidlee", :username => "dave123", :admin => false)}
  let!(:user2){FactoryGirl.create(:user, :name => "Joellee", :username => "joe123", :admin => false)}
  let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "RestoHouse", :user => user1, :status => 'Accepted')}
  let!(:post1){FactoryGirl.create(:post, :restaurant => restaurant1, :comment => "THIS IS AN ANNOUNCEMENT")}
  let!(:rating1){FactoryGirl.create(:rating, :restaurant => restaurant1, :rate => 4, :user => user2)}
  
  context "User logged in" do
    before(:each) do
      sign_in user2
    end
    
    describe "post#create" do
      context "Like a Rating" do
        context "non-user page" do
          before(:each) do
            xhr :post, :create, :rate_id => rating1.id
          end
        
          it "should like the rating" do
            expect(rating1.likes).to include(Like.last)
          end
        
          it "should increase number of likes" do
             expect(Like.count).to eq(1)
          end
        
          it "should render create template" do
            expect(response).to render_template('create')
          end
        end
        
        context "user page" do
          before(:each) do
            xhr :post, :create, :rate_id => rating1.id, :user_page => user2.id
          end
        
          it "should like the rating" do
            expect(rating1.likes).to include(Like.last)
          end
        
          it "should increase number of likes" do
             expect(Like.count).to eq(1)
          end
        
          it "should render create template" do
            expect(response).to render_template('create')
          end
        end
      end
      context "Like a Post" do
        before(:each) do
          xhr :post, :create, :post_id => post1.id, :user_page => user2.id
        end
      
        it "should like the post" do
          expect(post1.likes).to include(Like.last)
        end
      
        it "should increase number of likes" do
           expect(Like.count).to eq(1)
        end
      
        it "should render create template" do
          expect(response).to render_template('create')
        end
      end
    end
  
    describe "delete#destroy" do
      context "Unlike a Rating" do
        context "Non-user page" do
          before(:each) do
            xhr :post, :create, :rate_id => rating1.id
            xhr :delete, :destroy, :rating => rating1.id, :user => user2.id
          end
          
          it "should unlike the rating" do
            expect(rating1.likes.empty?).to be true
          end
        
          it "should increase number of likes" do
            expect(Like.count).to eq(0)
          end
        
          it "should render create template" do
            expect(response).to render_template('destroy')
          end
        end
        
        context "User page" do
          before(:each) do
            xhr :post, :create, :rate_id => rating1.id
            xhr :delete, :destroy, :rating => rating1.id, :user => user2.id, :user_page => user2.id
          end
          
          it "should unlike the rating" do
            expect(rating1.likes.empty?).to be true
          end
        
          it "should increase number of likes" do
            expect(Like.count).to eq(0)
          end
        
          it "should render create template" do
            expect(response).to render_template('destroy')
          end
        end
        
      end
    end
  end
end