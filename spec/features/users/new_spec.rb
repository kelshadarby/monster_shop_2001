require 'rails_helper'

RSpec.describe "As a user", type: :feature do
  describe 'When creating an new user account I' do
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
      @user2 = User.new(
        email_address: "user2@example.com",
        password: "password",
        name: "User 2",
        street_address: "123 Example St",
        city: "Userville",
        state: "State 2",
        zip_code: "12345"
      )
    end
    it "can register a new user with a unique email" do
      user3 = User.new(
        email_address: "user3@example.com",
        password: "password",
        name: "User 3",
        street_address: "123 Example St",
        city: "Userville",
        state: "State 3",
        zip_code: "12345"
      )

      visit '/'

      click_link 'Register'

      expect(current_path).to eq '/register'
      fill_in "Name", with: user3.name
      fill_in "Street Address", with: user3.street_address
      fill_in "City", with: user3.city
      fill_in "State", with: user3.state
      fill_in "Zip Code", with: user3.zip_code
      fill_in "Email Address", with: user3.email_address
      fill_in "Password", with: user3.password
      fill_in "Confirm Password", with: user3.password
      click_button "Submit"

      expect(current_path).to eq '/profile'
      expect(page).to have_content("Registration sucessful! You are now logged in.")
    end
    it "cannot register a user if form is incomplete" do
      visit '/register'

      fill_in "Name", with: @user1.name
      # fill_in "Street", with: @user1.street_address
      fill_in "City", with: @user1.city
      fill_in "State", with: @user1.state
      fill_in "Zip Code", with: @user1.zip_code
      fill_in "Email Address", with: @user1.email_address
      fill_in "Password", with: @user1.password
      fill_in "Confirm Password", with: @user1.password
      click_button "Submit"

      expect(page).to have_content("Street address can't be blank")

    end
    it "cannot create a user with a duplicate email address" do

      visit '/register'

      fill_in "Name", with: @user1.name
      fill_in "Street Address", with: @user1.street_address
      fill_in "City", with: @user1.city
      fill_in "State",  with: @user1.state
      fill_in "Zip Code", with: @user1.zip_code
      fill_in "Email Address", with: @user1.email_address
      fill_in "Password", with: @user1.password
      fill_in "Confirm Password", with: @user1.password
      click_button "Submit"

      visit '/register'

      @user2.email_address = @user1.email_address

      fill_in "Name", with: @user2.name
      fill_in "Street Address", with: @user2.street_address
      fill_in "City", with: @user2.city
      fill_in "State", with: @user2.state
      fill_in "Zip Code", with: @user2.zip_code
      fill_in "Email Address", with: @user2.email_address
      fill_in "Password", with: @user2.password
      fill_in "Confirm Password", with: @user2.password
      click_button "Submit"

      expect(User.all.count).to eq(1)

      expect(find_field("Name").value).to eq(@user2.name)
      expect(find_field("Street Address").value).to eq(@user2.street_address)
      expect(find_field("City").value).to eq(@user2.city)
      expect(find_field("State").value).to eq(@user2.state)
      expect(find_field("Zip Code").value).to eq(@user2.zip_code)
      expect(find_field("Email Address").value).to eq("")
      expect(find_field("Password").value).to eq("")

      expect(page).to have_content("Email is already in use.")
    end

    after(:all) do
      User.destroy_all
    end
  end
end
