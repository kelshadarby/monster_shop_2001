require 'rails_helper'

RSpec.describe "As a signed in user, when I visit /profile", type: :feature do
    it "there is a link I can click to edit profile information" do
      user1 = User.new(
        email_address: "user1@example.com",
        password: "password",
        name: "User 1",
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

      visit "/profile"
      expect(page).to have_link("Edit Profile")
      click_link("Edit Profile")

      fill_in "Name", with: "George"
      fill_in "Street Address", with: "123 fake street"
      fill_in "City", with: "Denver"
      fill_in "State", with: "CO"
      fill_in "Zip Code", with: "80205"

      click_button "Update Info"

      expect(current_path).to eq("/profile")
      expect(page).to have_content("Your information has been updated.")
      expect(page).to have_content("George")
      expect(page).to have_content("123 fake street")
      expect(page).to have_content("Denver")
      expect(page).to have_content("CO")
      expect(page).to have_content("80205")
      expect(page).to_not have_content("123 Example St")
      expect(page).to_not have_content("User 1")
    end

    it "there is a link to change user password" do
      user1 = User.new(
        email_address: "user1@example.com",
        password: "password",
        name: "User 1",
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

      visit "/profile"
      expect(page).to have_link("Change Password")
      click_link("Change Password")

      fill_in "Password", with: "BeanBurrito"
      fill_in "Confirm Password", with: "BeanBurritoo"

      click_button "Update Password"

      expect(page).to have_content("Passwords Must Match")

      fill_in "Password", with: "BeanBurrito"
      fill_in "Confirm Password", with: "BeanBurrito"

      click_button "Update Password"

      expect(page).to have_content("Password has been changed.")
      expect(current_path).to eq("/profile")
    end
end
