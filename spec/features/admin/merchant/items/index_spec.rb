require 'rails_helper'

RSpec.describe 'As an admin user', type: :feature do
  before(:each) do
     @user = User.create!( email_address: 'user1@example.com', password: 'password', role: 'default', name: 'User 1', street_address: '123 Example St', city: 'Userville', state: 'State 1', zip_code: '12345')
     @user2 = User.create!( email_address: 'user2@example.com', password: 'password', role: 'default', name: 'User 2', street_address: '123 Example St', city: 'Userville', state: 'State 1', zip_code: '12345')
     @admin1 = User.create!( email_address: 'merchant@example.com', password: 'password', role: 'admin', name: 'merchant', street_address: '123 admin St', city: 'adminville', state: 'State 5', zip_code: '54321')
     
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

    #  @meg.users << @admin1
     allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin1)
  end

  describe 'When I visit the merchant items page' do
    it 'I see all my items' do
      visit admin_merchant_items_path(@meg)
      within "#item-#{@tire.id}" do
        expect(page).to have_content(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content(@tire.price)
        expect(page).to have_css("img[src*='#{@tire.image}']")
        expect(page).to have_content("Active")
        expect(page).to have_content(@tire.inventory)
        expect(page).to have_link("Deactivate")
      end

      within "#item-#{@bottle.id}" do
        expect(page).to have_content(@bottle.name)
        expect(page).to have_content(@bottle.description)
        expect(page).to have_content(@bottle.price)
        expect(page).to have_css("img[src*='#{@bottle.image}']")
        expect(page).to have_content("Active")
        expect(page).to have_content(@bottle.inventory)
        expect(page).to have_link("Deactivate")
      end
    end

    it 'I click on deactivate and the item is deactivated' do
      visit admin_merchant_items_path(@meg)

      within "#item-#{@tire.id}" do
        click_link "Deactivate"
      end
      expect(current_path).to eq(admin_merchant_items_path(@meg))
      expect(page).to have_content("Item #{@tire.id} is not for sale")
      within "#item-#{@tire.id}" do
        expect(page).to_not have_content("Active")
        expect(page).to have_content("Inactive")
      end
    end

    it 'I click on deactivate and the item is activated' do
      visit admin_merchant_items_path(@meg)

      within "#item-#{@tire.id}" do
        click_link "Deactivate"
        click_link "Activate"
      end
      expect(current_path).to eq(admin_merchant_items_path(@meg))
      expect(page).to have_content("Item #{@tire.id} is for sale")
      within "#item-#{@tire.id}" do
        expect(page).to_not have_content("Inactive")
        expect(page).to have_content("Active")
      end
    end

    it 'I can delete never ordered items' do
      taco = @meg.items.create(name: "taco", description: "its a taco", price: 1, image: "https://upload.wikimedia.org/wikipedia/commons/3/3a/NCI_Visuals_Food_Taco.jpg", inventory: 5000)
      visit admin_merchant_items_path(@meg)

      within "#item-#{@tire.id}" do
        expect(page).to_not have_link("Delete")
      end

      within "#item-#{@bottle.id}" do
        expect(page).to_not have_link("Delete")
      end

      within "#item-#{taco.id}" do
        click_link("Delete")
      end
    end
  end

  after(:each) do
    ItemOrder.destroy_all
    Order.destroy_all
    User.destroy_all
    Merchant.destroy_all
  end
end
