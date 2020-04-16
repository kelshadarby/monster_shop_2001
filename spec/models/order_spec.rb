require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
    it {should belong_to :user }
  end

  describe 'instance methods' do
    before(:each) do
      @user = User.create!( email_address: 'user1@example.com', password: 'password', role: 'default', name: 'User 1', street_address: '123 Example St', city: 'Userville', state: 'State 1', zip_code: '12345')
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @bottle = @meg.items.create(name: "WaterBottle", description: "its a water battole", price: 20, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 24)

      @order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

      @item_order_tire = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @item_order_pull_toy = @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)

      @merchant1 = User.create!( email_address: 'merchant@example.com', password: 'password', role: 2, name: 'merchant', street_address: '123 admin St', city: 'adminville', state: 'State 5', zip_code: '54321')
      @meg.users << @merchant1

    end

    it 'grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it 'total_items' do
      expect(@order_1.total_items).to eq(5)
    end

    it 'status' do
      expect(@order_1.status).to eq("pending")

      @order_1.item_orders.each do |order_item|
        order_item.fulfill
      end

      expect(@order_1.status).to eq("packaged")
    end

    it 'cancel' do
      @item_order_tire.fulfill
      @order_1.cancel

      expect(@tire.inventory).to eq(12)
      expect(@pull_toy.inventory).to eq(32)
      expect(@order_1.status).to eq("canceled")
      expect(@item_order_tire.status).to eq("unfulfilled")
    end

    it "total_cost_for_merchant" do
      expect(@order_1.total_cost_for_merchant(@meg.id)).to eq(200.0)
    end

    it "number_of_items_for_merchant" do
      expect(@order_1.number_of_items_for_merchant(@meg.id)).to eq(2)
    end

    it 'ship' do
      @item_order_tire.fulfill
      @item_order_pull_toy.fulfill
      @order_1.ship
      @order_1.reload

      expect(@order_1.status).to eq("shipped")
    end

    it 'set_order_packaged' do
      expect(@order_1.status).to eq("pending")
      @item_order_pull_toy.fulfill

      expect(@order_1.status).to eq("pending")
      @item_order_tire.fulfill
      
      expect(@order_1.status).to eq("packaged")
    end

    it 'canceled?' do
      @order_1.update(status: "canceled")

      expect(@order_1.canceled?).to eq(true)
    end

    it 'cancelable?' do

      expect(@order_1.cancelable?).to eq(true)

      @order_1.update(status: "canceled")
      
      expect(@order_1.cancelable?).to eq(false)
      
      @order_1.update(status: "shipped")
      
      expect(@order_1.cancelable?).to eq(false)
    end

    after(:each) do
      ItemOrder.destroy_all
      Order.destroy_all
      User.destroy_all
      Merchant.destroy_all
    end
  end
end
