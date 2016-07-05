FactoryGirl.define do
  factory :cuisine do
    sequence :name do |n|
      "Cuisine#{n}"
    end
    
    avatar { File.open("#{Rails.root}/spec/support/sisig.jpg") }
  end
end
