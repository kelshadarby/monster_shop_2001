require 'rails_helper'

RSpec.describe "As a signed in user, when I visit /profile", type: :feature do
  before(:each) do
    @user = User.create!(
      email_address: "user1@example.com",
      password: "password",
      name: "User 1",
      street_address: "123 Example St",
      city: "Userville",
      state: "State 1",
      zip_code: "12345"
    ) 
  end

  it "IF I have NO orders: I do not see a link to My Orders" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    visit profile_path

    expect(page).to_not have_link("My Orders")
  end

  it "IF I have orders: I can click a link to My Orders" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    order = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
    order.item_orders.create!(item: tire, price: tire.price, quantity: 2)
    
    visit profile_path

    click_link "My Orders"

    expect(current_path).to eq(profile_orders_path)
  end

  it 'Can cancel an order' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    order = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
    order_item = order.item_orders.create!(item: tire, price: tire.price, quantity: 2)
    
    visit profile_orders_show_path(order)
    click_link "Cancel Order"

    order.reload
    order_item.reload

    expect(Order.find(order.id).status).to eq("canceled")
    expect(order_item.status).to eq("unfulfilled")

    expect(current_path).to eq(profile_orders_path)
    expect(page).to have_content("Order #{order.id} Canceled")
    
    within  "#order-#{order.id}-details" do
      expect(page).to have_content("Canceled")
    end
  end

   after(:each) do
      ItemOrder.destroy_all
      Order.destroy_all
      User.destroy_all
      Merchant.destroy_all
    end
end
