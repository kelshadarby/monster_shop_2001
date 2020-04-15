require 'rails_helper'

RSpec.describe 'As an admin user', type: :feature do
  before(:each) do
     @user = User.create!( email_address: 'user1@example.com', password: 'password', role: 'default', name: 'User 1', street_address: '123 Example St', city: 'Userville', state: 'State 1', zip_code: '12345')
     @user2 = User.create!( email_address: 'user2@example.com', password: 'password', role: 'default', name: 'User 2', street_address: '123 Example St', city: 'Userville', state: 'State 1', zip_code: '12345')
     @admin = User.create!( email_address: 'admin@example.com', password: 'password', role: 3, name: 'admin', street_address: '123 admin St', city: 'adminville', state: 'State 5', zip_code: '54321')
     @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
     @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
     @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
     @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
     @order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
     @order_2 = @user.orders.create!(name: 'Brian', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: "packaged")
     @order_3 = @user2.orders.create!(name: 'Bryan', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: "shipped")
     @order_4 = @user2.orders.create!(name: 'Bryan', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: "canceled")
     @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
     @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
     @order_2.item_orders.create!(item: @tire, price: @tire.price, quantity: 7)
     @order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 9)
     @order_4.item_orders.create!(item: @tire, price: @tire.price, quantity: 9)

     allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end

  describe 'When I visit the admin dashboard' do
    it 'I see all orders in the system with id, date, and user who placed it linking to show page' do
      visit admin_path

       expect(find(".packaged-orders")).to appear_before(find(".pending-orders"))
       expect(find(".pending-orders")).to appear_before(find(".shipped-orders"))
       expect(find(".shipped-orders")).to appear_before(find(".canceled-orders"))

      within ".packaged-orders" do
        expect(page).to have_content("#{@order_2.id}")
        expect(page).to have_content(@order_2.created_at)
        expect(page).to have_link(@order_2.user.id, href: "/admin/users/#{@user.id}")
      end

      within ".pending-orders" do
        expect(page).to have_content("#{@order_1.id}")
        expect(page).to have_content(@order_1.created_at)
        expect(page).to have_link(@order_1.user.id, href: "/admin/users/#{@user.id}")
      end

      within ".shipped-orders" do
        expect(page).to have_content("#{@order_3.id}")
        expect(page).to have_content(@order_3.created_at)
        expect(page).to have_link(@order_3.user.id, href: "/admin/users/#{@user2.id}")
      end

      within ".canceled-orders" do
        expect(page).to have_content("#{@order_4.id}")
        expect(page).to have_content(@order_4.created_at)
        expect(page).to have_link(@order_4.user.id, href: "/admin/users/#{@user2.id}")
      end
    end

    it 'I can click a button next to every order marked packaged to ship it' do
      visit admin_path

      within ".packaged-orders" do
        within "#order-#{@order_2.id}-summary" do
          @order_2.item_orders.first.fulfill
          click_link "Ship Order"
          @order_2.reload
          expect(@order_2.status).to eq("shipped")
        end
      end
      within ".pending-orders" do
        expect(page).to_not have_link("Ship Order")
      end
      within ".shipped-orders" do
        expect(page).to_not have_link("Ship Order")
        expect(page).to have_content(@order_2.id)
      end
      within ".canceled-orders" do
        expect(page).to_not have_link("Ship Order")
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
