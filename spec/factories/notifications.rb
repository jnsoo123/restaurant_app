FactoryGirl.define do
  factory :notification do
    user nil
    message "MyText"
    status "MyString"
  end
end
