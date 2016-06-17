FactoryGirl.define do
  factory :rating do
    rate 1
    comment "MyText"
    restaurant nil
    user nil
  end
end
