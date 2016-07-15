# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(name: 'Admin', email: 'admin@admin.com', password: '123456789', password_confirmation: '123456789', username: 'admin', admin: true)

Location.create(address: 'Manila')
Location.create(address: 'Caloocan')
Location.create(address: 'Quezon City')
Location.create(address: 'Makati')
Location.create(address: 'Pasay')
Location.create(address: 'Laguna')
Location.create(address: 'Batangas')
Location.create(address: 'Novaliches')

File.open(Rails.root.join('app/assets/images/filipinocuisine.jpg')) do |f|
  Cuisine.create(name: 'Filipino', avatar: f)
end

File.open(Rails.root.join('app/assets/images/koreancuisine.jpg')) do |f|
  Cuisine.create(name: 'Korean', avatar: f)
end

File.open(Rails.root.join('app/assets/images/japanesecuisine.jpg')) do |f|
  Cuisine.create(name: 'Japanese', avatar: f)
end

File.open(Rails.root.join('app/assets/images/italiancuisine.jpg')) do |f|
  Cuisine.create(name: 'Italian', avatar: f)
end

File.open(Rails.root.join('app/assets/images/indiancuisine.jpg')) do |f|
  Cuisine.create(name: 'Indian', avatar: f)
end

File.open(Rails.root.join('app/assets/images/chinesecuisine.jpg')) do |f|
  Cuisine.create(name: 'Chinese', avatar: f)
end

File.open(Rails.root.join('app/assets/images/frenchcuisine.jpg')) do |f|
  Cuisine.create(name: 'French', avatar: f)
end

File.open(Rails.root.join('app/assets/images/americancuisine.jpg')) do |f|
  Cuisine.create(name: 'American', avatar: f)
end

File.open(Rails.root.join('app/assets/images/thaicuisine.jpg')) do |f|
  Cuisine.create(name: 'Thai', avatar: f)
end
