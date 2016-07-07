FactoryGirl.define do
  factory :notification do
    user nil
    message "MyText"
    status false
  end
end
