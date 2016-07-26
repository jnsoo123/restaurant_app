require 'rails_helper'

RSpec.describe Picture, type: :model do
  
  let!(:user1){FactoryGirl.create(:user, :admin => false, :name => 'Fredrickson')}
  let!(:restaurant1){FactoryGirl.create(:restaurant, :status => 'Accepted', :name => 'RestoHouse', :user_id => user1.id)}
  
  let!(:picture1){FactoryGirl.create(:picture, :restaurant_id => restaurant1.id, :user_id => user1.id, :pic =>  File.open("#{Rails.root}/spec/support/sisig.jpg")  )}
  let!(:picture2){FactoryGirl.create(:picture, :restaurant_id => restaurant1.id, :user_id => user1.id, :pic =>  File.open("#{Rails.root}/spec/support/sisig.png")  )}
  let!(:picture3){FactoryGirl.create(:picture, :restaurant_id => restaurant1.id, :user_id => user1.id, :pic =>  File.open("#{Rails.root}/spec/support/sisig.gif")  )}
  let!(:picture4){FactoryGirl.create(:picture, :restaurant_id => restaurant1.id, :user_id => user1.id, :pic =>  File.open("#{Rails.root}/spec/support/sisig.jpeg")  )}

  it { is_expected.to belong_to :restaurant }
  it { is_expected.to belong_to :user }

  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :pic }
  it { is_expected.to validate_presence_of :restaurant }

  it { is_expected.to allow_value(picture1.pic).for(:pic) }
  it { is_expected.to allow_value(picture2.pic).for(:pic) }
  it { is_expected.to allow_value(picture3.pic).for(:pic) }
  it { is_expected.to allow_value(picture4.pic).for(:pic) }
end
