require 'rails_helper'

RSpec.describe RepliesController, type: :controller do
  let!(:user1){FactoryGirl.create(:user, :name => "Joellee", :username => "joe123", :admin => false)}
  let!(:user2){FactoryGirl.create(:user, :name => "Jacklee", :username => 'jack123', :admin => false)}
  let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "Resto", :user_id => user1.id)}
  
  context "Logged in user" do
    before(:each) do
      sign_in user2
    end
    
    describe "get#new" do
      context "Non-user page" do
        context "Rating reply" do
          let!(:rating1){FactoryGirl.create(:rating, :user => user2, :rate => 4, :restaurant => restaurant1)}
          
          before(:each) do
            xhr :get, :new, :rate => rating1.id
          end

          it "renders new template" do
            expect(response).to render_template('new')
          end
        end
        
        context "Post reply" do
          let!(:post1){FactoryGirl.create(:post, :restaurant => restaurant1, :comment => "Some comment of mine")}
          
          before(:each) do
            xhr :get, :new, :post => post1.id
          end

          it "renders new template" do
            expect(response).to render_template('new')
          end
        end
      end
      
      context "User page" do
        context "Rating reply" do
          let!(:rating1){FactoryGirl.create(:rating, :user => user2, :rate => 4, :restaurant => restaurant1)}
          
          before(:each) do
            xhr :get, :new, :rate => rating1.id, :user => user2.id
          end

          it "renders new template" do
            expect(response).to render_template('new')
          end
        end
        
        context "Post reply" do
          let!(:post1){FactoryGirl.create(:post, :restaurant => restaurant1, :comment => "Some comment of mine")}
          
          before(:each) do
            xhr :get, :new, :post => post1.id, :user => user2.id
          end

          it "renders new template" do
            expect(response).to render_template('new')
          end
        end
      end
    end
  
    describe "get#create" do
      context "Non-user page" do
        context "Rating reply" do
          let!(:rating1){FactoryGirl.create(:rating, :user => user2, :rate => 4, :restaurant => restaurant1)}
          
          before(:each) do
            xhr :post, :create, :reply => FactoryGirl.attributes_for(:reply, :comment => "Some comment from me"), :rate => rating1.id
          end

          it "renders create template" do
            expect(response).to render_template('create')
          end
          
          it "has the latest reply added to ratings" do
            expect(rating1.replies).to include(Reply.last)
          end
          
          it "increases number of replies" do
            expect(Reply.count).to eq(1)
          end
        end
        
        context "Post reply" do
          let!(:post1){FactoryGirl.create(:post, :restaurant => restaurant1, :comment => "Some comment of mine")}
          
          before(:each) do
            xhr :post, :create, :reply => FactoryGirl.attributes_for(:reply, :comment => "Some text to reply"), :post => post1.id
          end

          it "renders create template" do
            expect(response).to render_template('create')
          end
          
          it "has the latest reply added to ratings" do
            expect(post1.replies).to include(Reply.last)
          end
          
          it "increases number of replies" do
            expect(Reply.count).to eq(1)
          end
        end
      end
      
      context "User page" do
        context "Rating reply" do
          let!(:rating1){FactoryGirl.create(:rating, :user => user2, :rate => 4, :restaurant => restaurant1)}
          
          before(:each) do
            xhr :post, :create, :reply => FactoryGirl.attributes_for(:reply, :user => user2, :comment => "Some comment from me"), :rate => rating1.id
          end

          it "renders create template" do
            expect(response).to render_template('create')
          end
          
          it "has the latest reply added to ratings" do
            expect(rating1.replies).to include(Reply.last)
          end
          
          it "increases number of replies" do
            expect(Reply.count).to eq(1)
          end
        end
        
        context "Post reply" do
          let!(:post1){FactoryGirl.create(:post, :restaurant => restaurant1, :comment => "Some comment of mine")}
          
          before(:each) do
            xhr :post, :create, :reply => FactoryGirl.attributes_for(:reply, :user => user2, :comment => "Some text to reply"),
                                :post => post1.id
          end
          
          it "renders create template" do
            expect(response).to render_template('create')
          end
          
          it "has the latest reply added to ratings" do
            expect(post1.replies).to include(Reply.last)
          end
          
          it "increases number of replies" do
            expect(Reply.count).to eq(1)
          end
        end
      end
      
    end
  end
end