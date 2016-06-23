FactoryGirl.define do
  factory :restaurant do
    sequence :name do |n|
      "Restaurant#{n}"
    end
    description "random text"
    address "random address"
    contact "some contact"
    status "Pending"
    low_price_range "9.99"
    high_price_range "10.99"
    map "MyText"
    user
  end
end
