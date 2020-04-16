require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "As a visitor When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
      expect(page).to_not have_link(@dog_bone.name)
    end

    it "I can see a list of all of the items "do
      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end
    end

    it 'I see an area with statistics' do
      user = User.create!( email_address: 'user1@example.com', password: 'password', role: 'default', name: 'User 1', street_address: '123 Example St', city: 'Userville', state: 'State 1', zip_code: '12345')
      pull_toy1 = @brian.items.create(name: "Pull Toy1", description: "Great pull toy!", price: 10, image: "https://tinyurl.com/rzhm3qd", inventory: 32)
      pull_toy2 = @brian.items.create(name: "Pull Toy2", description: "Great pull toy!", price: 10, image: "https://tinyurl.com/rzhm3qd", inventory: 32)
      pull_toy3 = @brian.items.create(name: "Pull Toy3", description: "Great pull toy!", price: 10, image: "https://tinyurl.com/rzhm3qd", inventory: 32)
      pull_toy4 = @brian.items.create(name: "Pull Toy4", description: "Great pull toy!", price: 10, image: "https://tinyurl.com/rzhm3qd", inventory: 32)
      pull_toy5 = @brian.items.create(name: "Pull Toy5", description: "Great pull toy!", price: 10, image: "https://tinyurl.com/rzhm3qd", inventory: 32)
      tire1 = @meg.items.create(name: "Gatorskins1", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 12)
      tire2 = @meg.items.create(name: "Gatorskins2", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 12)
      tire3 = @meg.items.create(name: "Gatorskins3", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 12)
      tire4 = @meg.items.create(name: "Gatorskins4", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 12)
      tire5 = @meg.items.create(name: "Gatorskins5", description: "They'll never pop!", price: 100, image: "https://tinyurl.com/tn7jnts", inventory: 12)
      order_1 = user.orders.create!(name: 'Meg1', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_2 = user.orders.create!(name: 'Meg2', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      item_order_20 = order_1.item_orders.create!(item: tire2, price: tire2.price, quantity: 200)
      item_order_50 = order_2.item_orders.create!(item: tire5, price: tire5.price, quantity: 50)
      item_order_40 = order_2.item_orders.create!(item: tire4, price: tire4.price, quantity: 40)
      item_order_3 = order_2.item_orders.create!(item: pull_toy3, price: pull_toy3.price, quantity: 30)
      item_order_3 = order_1.item_orders.create!(item: pull_toy3, price: pull_toy3.price, quantity: 3)
      item_order_30 = order_1.item_orders.create!(item: tire3, price: tire3.price, quantity: 30)
      item_order_2 = order_1.item_orders.create!(item: pull_toy2, price: pull_toy2.price, quantity: 20)
      item_order_10 = order_1.item_orders.create!(item: tire1, price: tire1.price, quantity: 10)
      item_order_5 = order_2.item_orders.create!(item: pull_toy5, price: pull_toy5.price, quantity: 5)
      item_order_4 = order_2.item_orders.create!(item: pull_toy4, price: pull_toy4.price, quantity: 4)
      item_order_1 = order_1.item_orders.create!(item: pull_toy1, price: pull_toy1.price, quantity: 2)

      visit '/items'

      within "article.popular-items" do
        expect(tire2.name).to appear_before(tire5.name, only_text: true)
        expect(tire5.name).to appear_before(tire4.name, only_text: true)
        expect(tire4.name).to appear_before(pull_toy3.name, only_text: true)
        expect(pull_toy3.name).to appear_before(tire3.name, only_text: true)

        within "#item-#{tire2.id}" do
          expect(page).to have_content("Purchased 200 times")
        end
      end

      within "article.unpopular-items" do
        expect(pull_toy1.name).to appear_before(pull_toy4.name, only_text: true)
        expect(pull_toy4.name).to appear_before(pull_toy5.name, only_text: true)
        expect(pull_toy5.name).to appear_before(tire1.name, only_text: true)
        expect(tire1.name).to appear_before(pull_toy2.name, only_text: true)

        within "#item-#{pull_toy1.id}" do
          expect(page).to have_content("Purchased 2 times")
        end
      end
    end

    it "I can click on all images" do
      visit '/items'

      find("a#item-image-#{@tire.id}").click
      expect(current_path).to eq("/items/#{@tire.id}")

      visit '/items'

      find("a#item-image-#{@pull_toy.id}").click
      expect(current_path).to eq("/items/#{@pull_toy.id}")

      visit '/items'
    end

    it "I do not see any items that are inactive listed" do
      visit '/items'

      expect(page).to have_content(@pull_toy.name)
      expect(page).to_not have_content(@dog_bone.name)
    end

    it 'I cannot edit items' do
      visit '/items'
      
      expect(page).to_not have_content("Edit #{@tire.name}")
    end
    it 'I cannot delete items' do
      visit '/items'
      
      expect(page).to_not have_content("Delete")
    end
  end
end
