require 'rails_helper'

RSpec.describe 'As an admin user', type: :feature do
  before(:each) do
     @user = User.create!( email_address: 'user1@example.com', password: 'password', role: 'default', name: 'User 1', street_address: '123 Example St', city: 'Userville', state: 'State 1', zip_code: '12345')
     @user2 = User.create!( email_address: 'user2@example.com', password: 'password', role: 'default', name: 'User 2', street_address: '123 Example St', city: 'Userville', state: 'State 1', zip_code: '12345')
     @merchant1 = User.create!( email_address: 'merchant@example.com', password: 'password', role: 2, name: 'merchant', street_address: '123 admin St', city: 'adminville', state: 'State 5', zip_code: '54321')
     @admin = User.create!( email_address: 'admin@example.com', password: 'password', role: 3, name: 'adminuser', street_address: '123 admin St', city: 'adminville', state: 'State 5', zip_code: '54321')
     @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
     @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
     @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
     @bottle = @meg.items.create(name: "WaterBottle", description: "its a water battole", price: 20, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 24)
     @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
     @order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
     @order_2 = @user.orders.create!(name: 'Brian', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: "packaged")
     @order_3 = @user2.orders.create!(name: 'Bryan', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: "shipped")
     @order_4 = @user2.orders.create!(name: 'Bryan', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: "canceled")
     @item_order_tire = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
     @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
     @order_1.item_orders.create!(item: @bottle, price: @bottle.price, quantity: 3)
     @order_2.item_orders.create!(item: @tire, price: @tire.price, quantity: 7)
     @order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 9)
     @order_4.item_orders.create!(item: @tire, price: @tire.price, quantity: 9)

     @meg.users << @merchant1
     allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end

  describe 'When I visit /merchants' do
    it 'I can click on their name to be taken to the admin/merchant/ show page' do
      visit "/merchants"
      expect(page).to have_link(@meg.name, href: "/admin/merchants/#{@meg.id}")
      expect(page).to have_link(@brian.name, href: "/admin/merchants/#{@brian.id}")
      click_link(@meg.name)
      expect(current_path).to eq("/admin/merchants/#{@meg.id}")
    end

    it "I can see everything the merchant would see on their show page" do
      visit("/admin/merchants/#{@meg.id}")
      expect(page).to have_content(@meg.name)
      expect(page).to have_content(@meg.address)
      expect(page).to have_content(@meg.city)
      expect(page).to have_content(@meg.state)
      expect(page).to have_content(@meg.zip)

      expect(page).to have_link(@order_1.id)
      expect(page).to have_content(@order_1.created_at)
      expect(page).to have_content("My Items: 5")
      expect(page).to have_content("Value of My Items: $260")
    end
  end
  after(:each) do
    ItemOrder.destroy_all
    Order.destroy_all
    User.destroy_all
    Merchant.destroy_all
  end
end
