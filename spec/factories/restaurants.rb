FactoryGirl.define do
  factory :restaurant do
    sequence :name do |n|
      "Restaurant#{n}"
    end
    address "random address"
    contact "392-3212"
    status "Pending"
    map "MyText"
    website "http://website@website.com"
    avatar { File.open("#{Rails.root}/spec/support/sisig.jpg") } 
    cover { File.open("#{Rails.root}/spec/support/sisig.jpg") }
    user
  end
end
