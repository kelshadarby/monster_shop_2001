require 'rails_helper'

RSpec.describe 'As an merchant user', type: :feature do
  before(:each) do
    @user = User.create!( email_address: 'user1@example.com', password: 'password', role: 'default', name: 'User 1', street_address: '123 Example St', city: 'Userville', state: 'State 1', zip_code: '12345')
    @user2 = User.create!( email_address: 'user2@example.com', password: 'password', role: 'default', name: 'User 2', street_address: '123 Example St', city: 'Userville', state: 'State 1', zip_code: '12345')
    @merchant1 = User.create!( email_address: 'merchant@example.com', password: 'password', role: 2, name: 'merchant', street_address: '123 admin St', city: 'adminville', state: 'State 5', zip_code: '54321')
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=78x58", inventory: 12)
    @bottle = @meg.items.create(name: "WaterBottle", description: "its a water battole", price: 20, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=78x58", inventory: 24)
    @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
    @order_2 = @user.orders.create!(name: 'Brian', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: "packaged")
    
    @order_1_pull_toy = @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    @order_1_bottle = @order_1.item_orders.create!(item: @bottle, price: @bottle.price, quantity: 4)
    @order_2_tire = @order_2.item_orders.create!(item: @tire, price: @tire.price, quantity: 7)


    @meg.users << @merchant1
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant1)
  end

  describe 'On my order show page' do
    it 'I can see the details of an order' do
      visit merchant_order_show_path(@order_1)

      expect(page).to have_content(@order_1.name)
      expect(page).to have_content(@order_1.address)
      expect(page).to have_content(@order_1.state)
      expect(page).to have_content(@order_1.zip)
      expect(page).to have_link(@bottle.name, href: item_show_path(@bottle))
      expect(page).to have_css("img[src*='#{@bottle.image}']")
      expect(page).to have_content(@order_1_bottle.price)
      expect(page).to have_content(@order_1_bottle.quantity)
      
      expect(page).to_not have_link(@pull_toy.name, href: item_show_path(@pull_toy))
      expect(page).to_not have_link(@tire.name, href: item_show_path(@tire))
    end

    it 'I can fulfill orders that I have enough inventory to fill' do
      visit merchant_order_show_path(@order_1)

      click_link "Fulfill"
      @bottle.reload

      expect(current_path).to eq(merchant_order_show_path(@order_1))
      expect(page).to have_content("#{@bottle.name} has been fulfilled")
      expect(page).to have_content("Fulfilled")
      expect(@bottle.inventory).to eq(20)
    end

    it 'I cannot fulfill orders that I do not have enough inventory to fill' do
      @order_1_bottle.update(quantity: 25)
      visit merchant_order_show_path(@order_1)

      expect(current_path).to eq(merchant_order_show_path(@order_1))
      expect(page).to have_content("Insufficient inventory")
    end
  end

  after(:each) do
    ItemOrder.destroy_all
    Order.destroy_all
    User.destroy_all
    Merchant.destroy_all
  end
end