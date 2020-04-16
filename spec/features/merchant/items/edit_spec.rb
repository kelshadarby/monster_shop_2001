require 'rails_helper'

RSpec.describe 'As an merchant user', type: :feature do
  before(:each) do
     @user = User.create!( email_address: 'user1@example.com', password: 'password', role: 'default', name: 'User 1', street_address: '123 Example St', city: 'Userville', state: 'State 1', zip_code: '12345')
     @user2 = User.create!( email_address: 'user2@example.com', password: 'password', role: 'default', name: 'User 2', street_address: '123 Example St', city: 'Userville', state: 'State 1', zip_code: '12345')
     @merchant1 = User.create!( email_address: 'merchant@example.com', password: 'password', role: 2, name: 'merchant', street_address: '123 admin St', city: 'adminville', state: 'State 5', zip_code: '54321')

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
     allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant1)
  end

  describe 'When I visit the merchant items page' do
    it "I see a link I can click to edit items" do
        visit merchant_items_path
        
        click_link("Edit #{@tire.name}")
        expect(current_path).to eq(merchant_item_edit_path(@tire))
        expect(find_field('Name').value).to eq "Gatorskins"
        expect(find_field('Price').value).to_not eq '$100.00'
        expect(find_field('Price').value).to eq '100'
        expect(find_field('Description').value).to eq "They'll never pop!"
        expect(find_field('Image').value).to eq("https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588")
        expect(find_field('Inventory').value).to eq '12'

        fill_in 'Name', with: "Skinny Tires"
        fill_in 'Price', with: 222
        fill_in 'Description', with: "Half the tire at twice the cost :^)"
        fill_in 'Image', with: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588"
        fill_in 'Inventory', with: 22

        click_button "Update Item"

        expect(current_path).to eq(merchant_items_path)

        expect(page).to have_content("Skinny Tires")
        expect(page).to have_content("Half the tire at twice the cost :^)")

    end

    it "wont let me edit items to have attributes that aren't valid" do
      visit merchant_item_edit_path(@tire)

      fill_in 'Name', with: ""
      fill_in 'Price', with: 222
      fill_in 'Description', with: "Half the tire at twice the cost :^)"
      fill_in 'Image', with: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588"
      fill_in 'Inventory', with: 22

      click_button "Update Item"

      expect(page).to have_content("Name can't be blank")
      fill_in 'Name', with: "Skinny Wheels"
      fill_in 'Price', with: ("-25")
      fill_in 'Inventory', with: ("-55")
      click_button "Update Item"
      expect(page).to have_content("Price must be greater than 0 and Inventory must be greater than or equal to 0")
    end

    it 'I get a flash message if I put a float into price or inventory' do
      visit merchant_item_edit_path(@tire)

      fill_in 'Name', with: "Gatorskins"
      fill_in 'Price', with: 0.7
      fill_in 'Description', with: "They'll never pop!"
      fill_in 'Image', with: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588"
      fill_in 'Inventory', with: 0.5

      click_button "Update Item"

      expect(page).to have_content("Price must be an integer and Inventory must be an integer")
      expect(page).to have_button("Update Item")
    end
  end
  
  after(:each) do
    ItemOrder.destroy_all
    Order.destroy_all
    User.destroy_all  
    Merchant.destroy_all
  end
end
