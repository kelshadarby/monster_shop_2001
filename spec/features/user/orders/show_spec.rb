require "rails_helper"

RSpec.describe "As a default user", type: :feature do
  describe "When I view an orders show page" do

    before(:each) do
      @user = User.create(
        email_address: 'user1@example.com',
        password: 'password',
        role: 'default',
        name: 'User 1',
        street_address: '123 Example St',
        city: 'Userville',
        state: 'State 1',
        zip_code: '12345'
      )
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)

      @tire = @meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      @paper = @mike.items.create(name: 'Lined Paper', description: 'Great for writing on!', price: 20, image: 'https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png', inventory: 3)
      @pencil = @mike.items.create(name: 'Yellow Pencil', description: 'You can write on paper with it!', price: 2, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)

      @order = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      @item_order_tire = @order.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @item_order_paper = @order.item_orders.create!(item: @paper, price: @paper.price, quantity: 2)
      @item_order_pencil = @order.item_orders.create!(item: @pencil, price: @pencil.price, quantity: 2)
      @all_item_orders = ItemOrder.where(order_id: @order.id)
    end

    it "I see all information about the order" do
       total_quantity = @all_item_orders.sum { |item| item.quantity }

      visit "/profile/orders"
      click_link "#{@order.id}"

      expect(current_path).to eq(user_order_show_path(@order))
      expect(page).to have_content(@order.id)
      expect(page).to have_content(@order.created_at.to_date)
      expect(page).to have_content(@order.updated_at.to_date)
      expect(page).to have_content(@order.status.capitalize())

      expect(page).to have_content(@tire.name)
      expect(page).to have_content(@paper.name)
      expect(page).to have_content(@pencil.name)

      expect(page).to have_content(@tire.description)
      expect(page).to have_content(@paper.description)
      expect(page).to have_content(@pencil.description)

      expect(page).to have_css("img[src*='#{@tire.image}']")
      expect(page).to have_css("img[src*='#{@paper.image}']")
      expect(page).to have_css("img[src*='#{@pencil.image}']")

      expect(page).to have_content(@item_order_tire.quantity)
      expect(page).to have_content(@item_order_paper.quantity)
      expect(page).to have_content(@item_order_pencil.quantity)

      expect(page).to have_content(@tire.price)
      expect(page).to have_content(@paper.price)
      expect(page).to have_content(@pencil.price)

      expect(page).to have_content(@item_order_tire.subtotal)
      expect(page).to have_content(@item_order_paper.subtotal)
      expect(page).to have_content(@item_order_pencil.subtotal)

      expect(page).to have_content("Total Quantity: #{total_quantity}")
      expect(page).to have_content(@order.grandtotal)
    end

    it 'Can cancel an order' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      @item_order_tire.fulfill
      visit user_order_show_path(@order)
      
      click_link "Cancel Order"

      @order.reload
      @item_order_tire.reload

      expect(Order.find(@order.id).status).to eq("canceled")
      expect(@item_order_tire.status).to eq("unfulfilled")

      expect(current_path).to eq(user_orders_path)
      expect(page).to have_content("Order #{@order.id} Canceled")
      
      within  "#order-#{@order.id}-details" do
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
end
