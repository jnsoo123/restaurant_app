FactoryGirl.define do
  factory :picture do
    restaurant nil
    status false
    user nil
    sequence :pic do |n|
      "picture#{n}.jpg"
    end 
  end
end
