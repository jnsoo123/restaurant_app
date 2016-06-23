FactoryGirl.define do
  factory :cuisine do
    sequence :name do |n|
      "Cuisine#{n}"
    end
    description "random stuff"
  end
end
