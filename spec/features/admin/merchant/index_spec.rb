require "rails_helper"

RSpec.describe "As an admin", type: :feature do
  describe "When I visit the admin's merchant index page" do

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
       @item_order_tire = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
       @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
       @order_2.item_orders.create!(item: @tire, price: @tire.price, quantity: 7)
       @order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 9)
       @order_4.item_orders.create!(item: @tire, price: @tire.price, quantity: 9)

       allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    end

    it "I can disable a merchant" do
      visit '/admin/merchants'

      within "#merchant-#{@meg.id}" do
        click_button "Disable"
      end

      expect(current_path).to eq('/admin/merchants')

      expect(page).to have_content(@meg.name)
      expect(page).to have_content(@brian.name)

      within "#merchant-#{@meg.id}" do
        expect(page).to have_content("Disabled")
        expect(page).to_not have_button("Disable")
      end

      within "#merchant-#{@brian.id}" do
        expect(page).to_not have_content("Disabled")
      end

      expect(page).to have_content("#{@meg.name} has been disabled.")
    end

    it "I can enable a merchant" do
      @meg.disable

      visit '/admin/merchants'

      within "#merchant-#{@brian.id}" do
        expect(page).to have_button("Disable")
        expect(page).to_not have_button("Enable")
      end

      within "#merchant-#{@meg.id}" do
        expect(page).to_not have_button("Disable")
        click_button("Enable")
      end

      expect(current_path).to eq('/admin/merchants')

      within "#merchant-#{@brian.id}" do
        expect(page).to have_button("Disable")
        expect(page).to_not have_button("Enable")
      end

      within "#merchant-#{@meg.id}" do
        expect(page).to have_button("Disable")
        expect(page).to_not have_button("Enable")
      end

      expect(page).to have_content("#{@meg.name} has been enabled.")
    end

    it "All items from a disabled merchant are inactive" do
      visit '/admin/merchants'

      within "#merchant-#{@meg.id}" do
        click_button "Disable"
      end

      @meg.items.each do |item|
        expect(item.active?).to eq(false)
      end
    end

    it "All items from an enabled merchant are active" do
      @meg.disable

      visit '/admin/merchants'

      within "#merchant-#{@meg.id}" do
        click_button "Enable"
      end

      @meg.reload

      @meg.items.each do |item|
        expect(item.active?).to eq(true)
      end
    end

    it "I see the city and state for each merchant" do
      visit '/admin/merchants'
      expect(page).to have_content(@meg.city)
      expect(page).to have_content(@meg.state)
      expect(page).to have_content(@brian.state)
      expect(page).to have_content(@meg.city)
    end

    it "merchants names are links to their show pages" do
      visit '/admin/merchants'
      expect(page).to have_link(@meg.name, :href => "/admin/merchants/#{@meg.id}")
      expect(page).to have_link(@brian.name, :href => "/admin/merchants/#{@brian.id}")
    end

    after(:each) do
      ItemOrder.destroy_all
      Order.destroy_all
      User.destroy_all
      Merchant.destroy_all
    end

  end
end
