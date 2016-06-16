FactoryGirl.define do
  factory :restaurant do
    name "MyString"
    description "MyText"
    address "MyText"
    contact "MyString"
    status "MyString"
    low_price_range "9.99"
    high_price_range "9.99"
    map "MyText"
  end
end
