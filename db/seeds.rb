# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(name: 'Administrator', email: 'admin@admin.com', password: '123456789', password_confirmation: '123456789', username: 'admin', admin: true)

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

User.create!(
  name: 'Toshi Okayasu',
  email: 'toshi@gmail.com',
  username: 'toshi',
  password: '123123',
  password_confirmation: '123123',
  admin: false
)

Restaurant.create!(
  name: 'Lingnam',
  address: '',
  contact: '123-123',
  status: 'Accepted',
  avatar: File.open(Rails.root + "app/assets/images/lingnamprofile.png"),
  cover: File.open(Rails.root + "app/assets/images/lingnamlogo.jpg"),
  user_id: 2,
  website: 'http://www.lingnam.com.ph'
)

Location.create!(
  latitude: 14.609525,
  longitude: 120.982246,
  restaurant: Restaurant.last
)

Restaurant.last.update!(
  address: Location.last.address
)

Food.create!(
  name: "Beef Wanton Noodles",
  price: 198,
  cuisine: Cuisine.find_by(name: 'Chinese'),
  restaurant: Restaurant.last
)

Restaurant.create!(
  name: 'Love Desserts',
  address: '',
  contact: '02-2469069',
  status: 'Accepted',
  avatar: File.open(Rails.root + "app/assets/images/desserts_dp.jpg"),
  cover: File.open(Rails.root + "app/assets/images/desserts_cover.jpg"),
  user_id: 2
)

Location.create!(
  latitude: 14.639285,
  longitude: 121.000677,
  restaurant: Restaurant.last
)

Restaurant.last.update!(
  address: Location.last.address
)

Food.create!(
  name: "Eat All You Can Desserts Buffet",
  price: 200,
  cuisine: Cuisine.find_by(name: 'Filipino'),
  restaurant: Restaurant.last
)

Restaurant.create!(
  name: 'Sisig sa Rada',
  address: '',
  contact: '0917-1234567',
  status: 'Accepted',
  user_id: 2
)

Location.create!(
  latitude: 14.556205,
  longitude: 121.018608,
  restaurant: Restaurant.last
)

Restaurant.last.update!(
  address: Location.last.address
)

Food.create!(
  name: "Sisig with rice",
  price: 50,
  cuisine: Cuisine.find_by(name: 'Filipino'),
  restaurant: Restaurant.last
)

Food.create!(
  name: "Sisig no rice",
  price: 40,
  cuisine: Cuisine.find_by(name: 'Filipino'),
  restaurant: Restaurant.last
)

Restaurant.create!(
  name: 'The Frazzled Cook',
  address: '',
  contact: '02-3746879',
  status: 'Accepted',
  avatar: File.open(Rails.root + "app/assets/images/frazzledcooklogo.jpg"),
  cover: File.open(Rails.root + "app/assets/images/The-Frazzled-Cook-Interiors.jpg"),
  user_id: 2
)

Location.create!(
  latitude: 14.626998,
  longitude: 121.005163,
  restaurant: Restaurant.last
)

Restaurant.last.update!(
  address: Location.last.address
)

Food.create!(
  name: "Fish and Fries",
  description: "Breaded fish fillets and fries served with aioli dip.",
  price: 245,
  cuisine: Cuisine.find_by(name: 'French'),
  restaurant: Restaurant.last
)

Food.create!(
  name: "Grilled Tanigue Steak",
  description: "Marinated and grilled tanigue topped with our version of herbed butter.",
  price: 370,
  cuisine: Cuisine.find_by(name: 'Filipino'),
  restaurant: Restaurant.last
)

Food.create!(
  name: "Truffle Pasta",
  description: "Mixed pasta with sauteed Portobello mushroom and home made white truffle sauce.",
  price: 295,
  cuisine: Cuisine.find_by(name: 'Italian'),
  restaurant: Restaurant.last
)

Food.create!(
  name: "Tenderloin and Sausage Pizza",
  description: "Herbed crusted thin pizza dough topped with beef tenderloin salpicao, onion, and kesong puti",
  price: 295,
  cuisine: Cuisine.find_by(name: 'Filipino'),
  restaurant: Restaurant.last
)

