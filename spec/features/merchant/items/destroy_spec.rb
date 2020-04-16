require 'rails_helper'

RSpec.describe 'As a merchant', type: :feature do
  describe 'when I visit an item show page' do
    before(:each) do
      @user = User.create!( email_address: 'user1@example.com', password: 'password', role: 'default', name: 'User 1', street_address: '123 Example St', city: 'Userville', state: 'State 1', zip_code: '12345')
      @user2 = User.create!( email_address: 'user2@example.com', password: 'password', role: 'default', name: 'User 2', street_address: '123 Example St', city: 'Userville', state: 'State 1', zip_code: '12345')
      @merchant1 = User.create!( email_address: 'merchant@example.com', password: 'password', role: 2, name: 'merchant', street_address: '123 admin St', city: 'adminville', state: 'State 5', zip_code: '54321')

      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @taco = @meg.items.create(name: "Taco", description: "Its a Taco", price: 10, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 1)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @bottle = @meg.items.create(name: "WaterBottle", description: "its a water battole", price: 20, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 24)

        @review_1 = @taco.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)


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
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant1)
    end
    
    it 'I can delete an item' do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      visit merchant_item_show_path(@taco)

      expect(page).to have_link("Delete Item")
      click_on "Delete Item"

      expect(current_path).to eq(merchant_items_path)
      expect("item-#{chain.id}").to be_present
    end

    it 'I can delete items and it deletes reviews' do
      visit merchant_item_show_path(@taco)

      click_on "Delete Item"
      expect(Review.where(id:@review_1.id)).to be_empty
    end

    it 'I can not delete items with orders' do 
      visit merchant_item_show_path(@tire)
 
      expect(page).to_not have_link("Delete Item")
    end
    
    after(:all) do
      ItemOrder.destroy_all
      Order.destroy_all
      User.destroy_all  
      Merchant.destroy_all
    end
  end
end
