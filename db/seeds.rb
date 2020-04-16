# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ItemOrder.destroy_all
Order.destroy_all
User.destroy_all
Merchant.destroy_all

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)


#bike_shop items
tire1 = bike_shop.items.create(name: "Gatorskins1", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 62)
tire2 = bike_shop.items.create(name: "Gatorskins2", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 62)
tire3 = bike_shop.items.create(name: "Gatorskins3", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 62)
tire4 = bike_shop.items.create(name: "Gatorskins4", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 62)
tire5 = bike_shop.items.create(name: "Gatorskins5", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 62)

#dog_shop items
pull_toy1 = dog_shop.items.create(name: "Pull Toy1", description: "Great pull toy!", price: 10, image: "https://shipsunshine.com/wp-content/uploads/2018/01/Dog-Rope_Pink-1_5830-1-e1585872376177.jpg", inventory: 72)
pull_toy2 = dog_shop.items.create(name: "Pull Toy2", description: "Great pull toy!", price: 10, image: "https://shipsunshine.com/wp-content/uploads/2018/01/Dog-Rope_Pink-1_5830-1-e1585872376177.jpg", inventory: 72)
pull_toy3 = dog_shop.items.create(name: "Pull Toy3", description: "Great pull toy!", price: 10, image: "https://shipsunshine.com/wp-content/uploads/2018/01/Dog-Rope_Pink-1_5830-1-e1585872376177.jpg", inventory: 72)
pull_toy4 = dog_shop.items.create(name: "Pull Toy4", description: "Great pull toy!", price: 10, image: "https://shipsunshine.com/wp-content/uploads/2018/01/Dog-Rope_Pink-1_5830-1-e1585872376177.jpg", inventory: 72)
pull_toy5 = dog_shop.items.create(name: "Pull Toy5", description: "Great pull toy!", price: 10, image: "https://shipsunshine.com/wp-content/uploads/2018/01/Dog-Rope_Pink-1_5830-1-e1585872376177.jpg", inventory: 72)
dog_bone1  = dog_shop.items.create(name: "Dog Bone1", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
dog_bone2  = dog_shop.items.create(name: "Dog Bone2", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
dog_bone3  = dog_shop.items.create(name: "Dog Bone3", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

admin = User.create( email_address: 'admin@example.com', password: 'password_admin', role: 'admin', name: 'Adam the Admin', street_address: '123 Example St', city: 'Userville', state: 'State 1', zip_code: '12345')
merchant = User.create( email_address: 'merchant@example.com', password: 'password_merchant', role: 'merchant', name: 'Mary the Merchant', street_address: '123 Example St', city: 'Userville', state: 'State 1', zip_code: '12345')
merchant2 = User.create( email_address: 'merchant2@example.com', password: 'password_merchant', role: 'merchant', name: 'Meradith the Merchant', street_address: '1234 Example St', city: 'Userville', state: 'State 1', zip_code: '12345')
user = User.create( email_address: 'user@example.com', password: 'password_regular', role: 'default', name: 'Ulysses the User', street_address: '123 Example St', city: 'Userville', state: 'State 1', zip_code: '12345')
bike_shop.users << merchant
dog_shop.users << merchant2

order_1 = user.orders.create!(name: 'Ulysses', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
order_2 = user.orders.create!(name: 'Ulysses', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
item_order_20 = order_1.item_orders.create!(item: tire2, price: tire2.price, quantity: 10)
item_order_50 = order_2.item_orders.create!(item: tire5, price: tire5.price, quantity: 5)
item_order_40 = order_2.item_orders.create!(item: tire4, price: tire4.price, quantity: 20)
item_order_3 = order_2.item_orders.create!(item: pull_toy3, price: pull_toy3.price, quantity: 15)
item_order_3 = order_1.item_orders.create!(item: pull_toy3, price: pull_toy3.price, quantity: 3)
item_order_30 = order_1.item_orders.create!(item: tire3, price: tire3.price, quantity: 30)
item_order_2 = order_1.item_orders.create!(item: pull_toy2, price: pull_toy2.price, quantity: 20)
item_order_10 = order_1.item_orders.create!(item: tire1, price: tire1.price, quantity: 10)
item_order_5 = order_2.item_orders.create!(item: pull_toy5, price: pull_toy5.price, quantity: 5)
item_order_4 = order_2.item_orders.create!(item: pull_toy4, price: pull_toy4.price, quantity: 4)
item_order_1 = order_1.item_orders.create!(item: pull_toy1, price: pull_toy1.price, quantity: 2)
