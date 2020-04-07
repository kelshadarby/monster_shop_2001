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
  it "cannot register a user if form is incomplete" do

    visit '/register'
    fill_in "Name", with: "User 1"
    # fill_in "Street Address", with: "123 Example St"
    fill_in "City", with: "Userville"
    fill_in "State", with: "State 1"
    fill_in "Zip Code", with: "12345"
    fill_in "Email Address", with: "user@example.com"
    fill_in "Password", with: "password"
    fill_in "Confirm Password", with: "password"
    click_button "Submit"

    expect(page).to have_content("Registration unsucessful. Please fill in required fields. 😱")
    expect(current_path).to eq '/register'
  end
  it "cannot create a user with a duplicate email address" do
    visit '/register'

    fill_in "Name", with: "User 1"
    fill_in "Street Address", with: "123 Example St"
    fill_in "City", with: "Userville"
    fill_in "State", with: "State 1"
    fill_in "Zip Code", with: "12345"
    fill_in "Email Address", with: "user@example.com"
    fill_in "Password", with: "password"
    fill_in "Confirm Password", with: "password"
    click_button "Submit"

    visit '/register'

    fill_in "Name", with: "User 2"
    fill_in "Street Address", with: "124 Example St"
    fill_in "City", with: "Usertown"
    fill_in "State", with: "State 2"
    fill_in "Zip Code", with: "12346"
    fill_in "Email Address", with: "user@example.com"
    fill_in "Password", with: "password"
    fill_in "Confirm Password", with: "password"
    click_button "Submit"

    expect(current_path).to eq '/register'
    expect(User.all.count).to eq(1)

    expect(find_field("Name").value).to eq("User 2")
    expect(find_field("Street Address").value).to eq("124 Example St")
    expect(find_field("City").value).to eq("Usertown")
    expect(find_field("State").value).to eq("State 2")
    expect(find_field("Zip Code").value).to eq("12346")
    expect(find_field("Email Address").value).to eq("")
    expect(find_field("Password").value).to eq("")

    expect(page).to have_content("Email is already in use.")
  end
end
