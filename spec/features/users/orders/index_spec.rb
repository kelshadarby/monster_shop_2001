# require "rails_helper"
#
RSpec.describe "As a user", type: :feature do
    it "Displays every order ive made and its attributes" do
      mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      user1 = User.new(
             email_address: "user1@example.com",
             password: "password",
             name: "Bart",
             street_address: "123 Example St",
             city: "Userville",
             state: "State 1",
             zip_code: "12345"
           )
           user1.save

           visit '/login'
           fill_in "Email Address", with: user1.email_address
           fill_in "Password", with: user1.password
           click_button "Login"

           visit "/items/#{paper.id}"
           click_on "Add To Cart"
           visit "/items/#{pencil.id}"
           click_on "Add To Cart"

           visit "/cart"
           click_on "Checkout"

           fill_in :name, with: "Bart"
           fill_in :address, with: "123 street st"
           fill_in :city, with: "Denver"
           fill_in :state, with: "CO"
           fill_in :zip, with: 80205

           click_button "Create Order"

           new_order = Order.last

           visit "/profile/orders"

           expect(page).to have_link(new_order.id)
           expect(page).to have_content(new_order.created_at)
           expect(page).to have_content(new_order.updated_at)
           expect(page).to have_content(new_order.grandtotal)
           expect(page).to have_content(new_order.total_items)
           expect(page).to have_content(new_order.status.capitalize)
    end
  end
