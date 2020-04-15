require "rails_helper"

RSpec.describe "As a merchant user (role 2)", type: :feature do
  it "can see same links as regular user plus link to merchant dashboard" do
    merchant_user = User.create(
      email_address: "user1@example.com",
      password: "password",
      role: "merchant",
      name: "User 1",
      street_address: "123 Example St",
      city: "Userville",
      state: "State 1",
      zip_code: "12345"
    )
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    meg.users << merchant_user

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

    visit "/"

    click_link("Home")
    expect(current_path).to eq(root_path)

    click_link("All Merchants")
    expect(current_path).to eq(merchants_path)

    click_link("All Items")
    expect(current_path).to eq(items_path)

    click_link("Cart: 0")
    expect(current_path).to eq(cart_path)

    click_link("Profile")
    expect(current_path).to eq('/profile')

    click_link("Logout")
    expect(current_path).to eq(root_path)

    click_link("Dashboard")
    expect(current_path).to eq(merchant_path)
  end
  it "cannot view unauthorized admin pages" do
    merchant_user = User.create(
      email_address: "user1@example.com",
      password: "password",
      role: "merchant",
      name: "User 1",
      street_address: "123 Example St",
      city: "Userville",
      state: "State 1",
      zip_code: "12345"
    )
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    meg.users << merchant_user

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

    visit "/admin"
    expect(page).to have_content("The page you were looking for doesn't exist (404)")

    visit "/admin/users"
    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end
end
