require 'rails_helper'

RSpec.describe "As a user", type: :feature do
  it "can register a new user with a unique email" do
    visit '/'

    click_link 'Register'

    expect(current_path).to eq '/register'

    fill_in "Name", with: "User 1"
    fill_in "Street Address", with: "123 Example St"
    fill_in "City", with: "Userville"
    fill_in "State", with: "State 1"
    fill_in "Zip Code", with: "12345"
    fill_in "Email Address", with: "user@example.com"
    fill_in "Password", with: "password"
    fill_in "Confirm Password", with: "password"
    click_button "Submit"

    expect(current_path).to eq '/profile'
    expect(page).to have_content("Registration sucessful! You are now logged in.")
  end
end
