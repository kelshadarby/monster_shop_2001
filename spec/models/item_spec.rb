require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @user = User.create!( email_address: 'user1@example.com', password: 'password', role: 'default', name: 'User 1', street_address: '123 Example St', city: 'Userville', state: 'State 1', zip_code: '12345')
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      order = @user.orders.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end

    it 'deletable?' do
      tire1 = @bike_shop.items.create(name: "Gatorskins1", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 1)
      tire2 = @bike_shop.items.create(name: "Gatorskins2", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 2)

      order_1 = @user.orders.create!(name: 'Meg1', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      item_order_1 = order_1.item_orders.create!(item: tire1, price: tire1.price, quantity: 1)

      expect(tire1.deletable?).to eq(false)
      expect(tire2.deletable?).to eq(true)
    end

    it "deactivate" do
      expect(@chain.active?).to eq(true)
      @chain.deactivate
      expect(@chain.active?).to eq(false)
    end

    it "activate" do
      @chain.deactivate
      expect(@chain.active?).to eq(false)
      @chain.activate
      expect(@chain.active?).to eq(true)
    end

  end

  describe "class methods" do
    before(:each) do
      @user = User.create!( email_address: 'user1@example.com', password: 'password', role: 'default', name: 'User 1', street_address: '123 Example St', city: 'Userville', state: 'State 1', zip_code: '12345')
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    end

    it 'most_popular' do
      tire1 = @bike_shop.items.create(name: "Gatorskins1", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 1)
      tire2 = @bike_shop.items.create(name: "Gatorskins2", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 2)
      tire3 = @bike_shop.items.create(name: "Gatorskins3", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 3)
      tire4 = @bike_shop.items.create(name: "Gatorskins4", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 4)
      tire5 = @bike_shop.items.create(name: "Gatorskins5", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 5)
      tire6 = @bike_shop.items.create(name: "Gatorskins6", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 6)
      order_1 = @user.orders.create!(name: 'Meg1', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_2 = @user.orders.create!(name: 'Meg2', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      item_order_2 = order_1.item_orders.create!(item: tire2, price: tire2.price, quantity: 20)
      item_order_7 = order_2.item_orders.create!(item: tire1, price: tire1.price, quantity: 10)
      item_order_1 = order_1.item_orders.create!(item: tire1, price: tire1.price, quantity: 1)
      item_order_6 = order_2.item_orders.create!(item: tire6, price: tire1.price, quantity: 6)
      item_order_5 = order_2.item_orders.create!(item: tire5, price: tire5.price, quantity: 5)
      item_order_4 = order_2.item_orders.create!(item: tire4, price: tire4.price, quantity: 4)
      item_order_3 = order_1.item_orders.create!(item: tire3, price: tire3.price, quantity: 3)

      expect(Item.most_popular(5)).to eq([tire2, tire1, tire6, tire5, tire4])
    end

    it 'least_popular' do

      tire1 = @bike_shop.items.create(name: "Gatorskins1", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 1)
      tire2 = @bike_shop.items.create(name: "Gatorskins2", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 2)
      tire3 = @bike_shop.items.create(name: "Gatorskins3", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 3)
      tire4 = @bike_shop.items.create(name: "Gatorskins4", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 4)
      tire5 = @bike_shop.items.create(name: "Gatorskins5", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 5)
      tire6 = @bike_shop.items.create(name: "Gatorskins6", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 6)
      order_1 = @user.orders.create!(name: 'Meg1', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_2 = @user.orders.create!(name: 'Meg2', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      item_order_2 = order_1.item_orders.create!(item: tire2, price: tire2.price, quantity: 20)
      item_order_7 = order_2.item_orders.create!(item: tire1, price: tire1.price, quantity: 10)
      item_order_1 = order_1.item_orders.create!(item: tire1, price: tire1.price, quantity: 1)
      item_order_6 = order_2.item_orders.create!(item: tire6, price: tire6.price, quantity: 6)
      item_order_5 = order_2.item_orders.create!(item: tire5, price: tire5.price, quantity: 5)
      item_order_4 = order_2.item_orders.create!(item: tire4, price: tire4.price, quantity: 4)
      item_order_3 = order_1.item_orders.create!(item: tire3, price: tire3.price, quantity: 3)

      expect(Item.least_popular(5)).to eq([tire3, tire4, tire5, tire6, tire1])
    end

    after(:each) do
      ItemOrder.destroy_all
      Order.destroy_all
      User.destroy_all
      Merchant.destroy_all
    end

  end
end
