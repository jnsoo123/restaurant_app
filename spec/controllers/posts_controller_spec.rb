require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let!(:user1){FactoryGirl.create(:user, :name => "Davidly", :username => "dave123", :admin => false)}
  let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "RestoHouse", :user => user1, :status => 'Accepted')}
  
  context "Logged in as owner" do
    before(:each) do
      sign_in user1
    end
    
    describe "get#new" do
      before(:each) do
        xhr :get, :new, :resto_id => restaurant1.id
      end
      
      it "renders new template" do
        expect(response).to render_template('new')
      end
    end
  
    describe "post#create" do
      before(:each) do
        xhr :post, :create, :resto_id => restaurant1.id, :post => FactoryGirl.attributes_for(:post, :comment => "THIS IS SOME RANDOM COMMENT")
      end
      
      it "creates a new post" do
        expect(Post.count).to eq(1)
      end
      
      it "creates a new post with comment 'THIS IS SOME RANDOM COMMENT'" do
        expect(Post.last.comment).to match('THIS IS SOME RANDOM COMMENT') 
      end
      
      it "renders create template" do
        expect(response).to render_template('create')
      end
    end
  
    context "Changing Post" do 
      before(:each) do
        xhr :post, :create, :resto_id => restaurant1.id, :post => FactoryGirl.attributes_for(:post, :comment => "THIS IS SOME RANDOM COMMENT")
        @post1 = Post.last
      end
  
      describe "get#edit" do
        before(:each) do
          xhr :get, :edit, :id => @post1.id
        end
      
        it "renders edit template" do
            expect(response).to render_template('edit')
        end
      end
  
      describe "put#update" do
        before(:each) do
          xhr :put, :update, :id => @post1.id, :post => FactoryGirl.attributes_for(:post, :comment => "CHANGED THIS COMMENT")
          @post1.reload
        end
        
        it "updates the comment" do
          expect(@post1.comment).to match('CHANGED THIS COMMENT')
        end
        
        it "renders update template" do
            expect(response).to render_template('update')
        end
      end

      describe "delete#destroy" do
        before(:each) do
          xhr :delete, :destroy, :id => @post1.id
        end
      
        it "should destroy the post" do
          expect(Post.exists?(@post1.id)).to be false
        end
        
        it "should decrease number of posts" do
          expect(Post.count).to eq(0)
        end
        
        it "renders destroy template" do
          expect(response).to render_template('destroy')
        end
      end
    end
  
    describe "get#show_more" do
      let!(:user2){FactoryGirl.create(:user, :name => "Fredrickson", :username => "fred123", :admin => false)}
      let!(:user3){FactoryGirl.create(:user, :name => "Joellee", :username => "joe123", :admin => false)}
      let!(:user4){FactoryGirl.create(:user, :name => "Jacklee", :username => "jack123", :admin => false)}
      let!(:user5){FactoryGirl.create(:user, :name => "George", :username => "george123", :admin => false)}
      
      context "display replies on rating" do
        let!(:rating1){FactoryGirl.create(:rating, :restaurant => restaurant1, :user => user3)}
        let!(:reply1){FactoryGirl.create(:reply, :rating => rating1, :user => user2)}
        let!(:reply2){FactoryGirl.create(:reply, :rating => rating1, :user => user3)}
        let!(:reply3){FactoryGirl.create(:reply, :rating => rating1, :user => user4)}
        let!(:reply4){FactoryGirl.create(:reply, :rating => rating1, :user => user5)}
      
        before(:each) do
          xhr :get, :show_more, :more => true, :id => restaurant1.id
        end
      
        it "renders show more template" do
          expect(response).to render_template('show_more')
        end
      
        it "sets variables for js" do
          expect(assigns(:all)).to be true
          expect(assigns(:restaurant)).to eq(restaurant1)
        end
      end
      
      context "display replies on post" do
        let!(:post3){FactoryGirl.create(:post, :restaurant => restaurant1, :comment => "Some random comment")}
        let!(:reply1){FactoryGirl.create(:reply, :post => post3, :user => user2)}
        let!(:reply2){FactoryGirl.create(:reply, :post => post3, :user => user3)}
        let!(:reply3){FactoryGirl.create(:reply, :post => post3, :user => user4)}
        let!(:reply4){FactoryGirl.create(:reply, :post => post3, :user => user5)}
      
        before(:each) do
          xhr :get, :show_more, :more => true, :id => restaurant1.id
        end
      
        it "renders show more template" do
          expect(response).to render_template('show_more')
        end
      
        it "sets variables for js" do
          expect(assigns(:all)).to be true
          expect(assigns(:restaurant)).to eq(restaurant1)
        end
      end
    end
  end
end