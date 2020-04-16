require "rails_helper"

RSpec.describe "As a merchant user", type: :feature do
  before(:each) do
    @merchant1 = User.create!( email_address: 'merchant@example.com', password: 'password', role: 2, name: 'merchant', street_address: '123 admin St', city: 'adminville', state: 'State 5', zip_code: '54321')

    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @meg.users << @merchant1

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant1)
  end

  it "I can click a link, completely fill in a form and add a new item" do
    visit merchant_items_path

    click_link "New Item"

    expect(current_path).to eq(merchant_items_new_path)

    name = "Pull Toy"
    description = "Great pull toy!"
    price = 10
    image_url = "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg"
    inventory = 32
    placeholder = "https://upload.wikimedia.org/wikipedia/commons/1/15/No_image_available_600_x_450.svg"

    expect(find_field("Image").value).to_not eq(placeholder)

    fill_in :name, with: name
    fill_in :price, with: price
    fill_in :description, with: description
    fill_in :image, with: image_url
    fill_in :inventory, with: inventory
    click_button "Create Item"

    expect(current_path).to eq(merchant_items_path)

    expect(page).to have_content("#{name} has been created.")
    expect(page).to have_content(name)
    expect(page).to have_content("$#{price}")
    expect(page).to have_content(description)
    expect(page).to have_css("img[src*='#{image_url}']")
    expect(page).to have_content(inventory)
    expect(page).to have_content(inventory)

    expect(page).to have_content("Active")
    expect(page).to_not have_content("Inactive")
    expect(page).to have_link("Deactivate")

    expect(page).to have_content("Item #{name} is for sale")
    expect(page).to_not have_content("Item #{name} is not for sale")
  end

  it "I can click a link, fill in a form without an image and add a new item" do
    visit merchant_items_path

    click_link "New Item"

    expect(current_path).to eq(merchant_items_new_path)

    name = "Pull Toy"
    description = "Great pull toy!"
    price = 10
    image_url = "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg"
    inventory = 32

    placeholder = "https://upload.wikimedia.org/wikipedia/commons/1/15/No_image_available_600_x_450.svg"

    fill_in :name, with: name
    fill_in :price, with: price
    fill_in :description, with: description
    # fill_in :image, with: image_url
    fill_in :inventory, with: inventory
    click_button "Create Item"

    expect(current_path).to eq(merchant_items_path)

    expect(page).to have_content("#{name} has been created.")
    expect(page).to have_content(name)
    expect(page).to have_content("$#{price}")
    expect(page).to have_content(description)
    expect(page).to have_css("img[src*='#{placeholder}']")
    expect(page).to_not have_css("img[src*='#{image_url}']")
    expect(page).to have_content(inventory)
    expect(page).to have_content(inventory)
    expect(page).to have_content("Active")
    expect(page).to_not have_content("Inactive")
    expect(page).to have_link("Deactivate")

    expect(page).to have_content("Item #{name} is for sale")
    expect(page).to_not have_content("Item #{name} is not for sale")
  end

  it "I cannot create an item without a name or description" do
    visit merchant_items_path

    click_link "New Item"

    expect(current_path).to eq(merchant_items_new_path)

    name = "Pull Toy"
    description = "Great pull toy!"
    price = 10
    image_url = "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg"
    inventory = 32

    # fill_in :name, with: name
    fill_in :price, with: price
    # fill_in :description, with: description
    fill_in :image, with: image_url
    fill_in :inventory, with: inventory
    click_button "Create Item"

    expect(page).to have_content("Name can't be blank and Description can't be blank")
    expect(find_field("Price").value).to eq(price.to_s)
    expect(find_field("Image").value).to eq(image_url)
    expect(find_field("Inventory").value).to eq(inventory.to_s)
  end

  it "I cannot create an item with a negative price or inventory" do
    visit merchant_items_path

    click_link "New Item"

    expect(current_path).to eq(merchant_items_new_path)

    name = "Pull Toy"
    description = "Great pull toy!"
    price = (0)
    image_url = "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg"
    inventory = (-1)

    fill_in :name, with: name
    fill_in :price, with: price
    fill_in :description, with: description
    fill_in :image, with: image_url
    fill_in :inventory, with: inventory
    click_button "Create Item"

    expect(page).to have_content("Price must be greater than 0 and Inventory must be greater than or equal to 0")
    expect(find_field("Price").value).to eq(price.to_s)
    expect(find_field("Image").value).to eq(image_url)
    expect(find_field("Inventory").value).to eq(inventory.to_s)
  end

  it "I cannot create an item with a float for a price or inventory" do
    visit merchant_items_path

    click_link "New Item"

    expect(current_path).to eq(merchant_items_new_path)

    name = "Pull Toy"
    description = "Great pull toy!"
    price = (0.5)
    image_url = "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg"
    inventory = (0.5)

    fill_in :name, with: name
    fill_in :price, with: price
    fill_in :description, with: description
    fill_in :image, with: image_url
    fill_in :inventory, with: inventory
    click_button "Create Item"

    expect(page).to have_content("Price must be an integer and Inventory must be an integer")
    expect(find_field("Price").value).to eq("0")
    expect(find_field("Image").value).to eq(image_url)
    expect(find_field("Inventory").value).to eq("0")
  end

  after(:each) do
    User.destroy_all
    Merchant.destroy_all
  end
end
