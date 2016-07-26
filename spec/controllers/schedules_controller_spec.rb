require 'rails_helper'

RSpec.describe SchedulesController, type: :controller do
  
  
  let!(:user1){FactoryGirl.create(:user, :name => "Davidly", :admin => false)}
  let!(:restaurant1){FactoryGirl.create(:restaurant, :name => "RestoAcc", :status => "Accepted", :user_id => user1.id)}
  let!(:schedule1){FactoryGirl.create(:schedule, :day => 'Monday', :opening => "8:00 PM", :closing => "11:00 PM", :restaurant_id => restaurant1.id)}
  
  before(:each) do
    sign_in user1
  end
  
  context "owner logged in" do    
    describe "get #new" do
      before(:each) do
       xhr :get, :new, :resto_id => restaurant1.id
      end
      
      it "creates a new instance of schedules for that restaurant" do
        schedule = assigns(:schedule)
        expect(schedule.restaurant).to eq(restaurant1)
        expect(schedule.opening).to be nil
        expect(schedule.closing).to be nil
        expect(schedule.day).to be nil
        expect(schedule.restaurant_id).not_to be nil
      end
      
      it "renders new template" do
        expect(response).to render_template('new')
      end
    end
    
    describe "get #edit" do
      before(:each) do
       xhr :get, :edit, :id => schedule1.id
      end
      
      it "renders edit template" do
        expect(response).to render_template('edit')
      end
      
      it "passes schedule entry" do
        expect(assigns(:schedule)).to eq(schedule1)
      end
    end
    
    describe "post #create" do
      before(:each) do
        xhr :post, :create, :schedule =>  FactoryGirl.attributes_for(:schedule, :opening => '10:00 AM', 
        :closing => "12:00 PM", :day => 'Tuesday'), :resto_id => restaurant1.id
      end
      
      it "creates a new schedule" do
        expect(Schedule.count).to eq(2)
      end
      
      it "creates a new schedule with opening time 10:00 AM" do
        expect(Schedule.find_by(day: "Tuesday").opening).to eq("10:00 AM")
      end
      
      it "renders owner restaurant edit page" do
        expect(response).to render_template('create')
      end
    end
    
    describe "delete #destroy" do
      before(:each) do
        @id = schedule1.id
        xhr :delete, :destroy, :id => schedule1.id
      end
      
      it "removes a schedule entry" do
        expect(Schedule.exists?(@id)).to be false
      end
      
      it "schedule count should be 0" do
        expect(Schedule.count).to eq(0)
      end
    end
    
    describe "put #update" do
      before(:each) do
        create(:restaurant, id: 123)
        @schedule = create(:schedule, day: 'Tuesday', opening: '12:30 PM', closing: '4:30 PM', restaurant_id: 123)
      end
      
      context 'with valid attributes' do
        it 'locates the requested @schedule' do
          put :update, id: @schedule, schedule: attributes_for(:schedule), format: :js
          expect(assigns(:schedule)).to eq(@schedule)
        end
        
        it 'changes the @schedule\'s attributes' do
          put :update, id: @schedule, schedule: attributes_for(:schedule, day: 'Wednesday', opening: '3:30 PM', closing: '5:30 PM', restaurant_id: 123), format: :js
          @schedule.reload
          expect(@schedule.day).to eq('Wednesday')
          expect(@schedule.opening).to eq('3:30 PM')
          expect(@schedule.closing).to eq('5:30 PM')
          
        end
      end
    end
  end
  
  
end