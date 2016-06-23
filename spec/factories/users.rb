FactoryGirl.define do
  factory :user do
    sequence :name do |n|
      "David#{n}"
    end
    sequence :username do |n|
      "Dave#{n}"
    end
    sequence :email do |n|
      "dave@#{n}.com"
    end 
    password 'secret'
    password_confirmation 'secret'
    location 'this is my location'
    profile_picture_url 'random/image'
    avatar 'random.jpg'
  end
end
