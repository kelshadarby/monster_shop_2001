require 'rails_helper'

RSpec.describe "As a user", type: :feature do
  describe "when I click the logout link" do
    before(:all) do
        @user1 = User.new(
          email_address: "user1@example.com",
          password: "password",
          name: "User 1",
          street_address: "123 Example St",
          city: "Userville",
          state: "State 1",
          zip_code: "12345"
        )
        @user1.save
    end

      it "destroys the session and shopping cart" do
        bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
        tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

        visit '/login'
        fill_in "Email Address", with: @user1.email_address
        fill_in "Password", with: @user1.password
        click_button "Login"

        visit "/items/#{tire.id}"
        click_button "Add To Cart"
        expect(page).to have_content("Cart: 1")

        expect(page).to have_link("Logout")
        click_link("Logout")

        expect(page).to have_content("Cart: 0")
        expect(page).to_not have_link("Logout")
        expect(page).to have_link("Login")
        expect(current_path).to eq(root_path)
        expect(page).to have_content("Logout Succesful")
      end

      after(:all) do
        User.destroy_all
      end
    end
end
