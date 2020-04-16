require 'spec_helper'
require 'rails_helper'

RSpec.describe 'As a Admin', type: :feature do
  describe 'I have a navbar' do
    it 'where I can click on' do
      user1 = User.new(
        email_address: "user1@example.com",
        role: 3,
        password: "password",
        name: "User 1",
        street_address: "123 Example St",
        city: "Userville",
        state: "State 1",
        zip_code: "12345"
      )
      user1.save

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)

      visit root_path

      click_on 'All Merchants'
      expect(current_path).to eq(merchants_path)

      click_on 'Home'
      expect(current_path).to eq(root_path)

      click_on 'All Items'
      expect(current_path).to eq(items_path)

      click_on 'Dashboard'
      expect(current_path).to eq(admin_path)

      click_on 'Users'
      expect(current_path).to eq(admin_users_path)

      click_on 'Profile'
      expect(current_path).to eq(profile_path)

      click_on 'Logout'
      expect(current_path).to eq(root_path)

      expect(page).to_not have_link('Cart')

      expect(page).to_not have_link('Login')

      expect(page).to_not have_link('Register')
    end
  end

  describe 'I do not have access' do
    it '/merchant routes' do
      user1 = User.new(
        email_address: "user1@example.com",
        role: 3,
        password: "password",
        name: "User 1",
        street_address: "123 Example St",
        city: "Userville",
        state: "State 1",
        zip_code: "12345"
      )
      user1.save
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)

      visit merchant_path
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end

    it '/cart routes' do
      user1 = User.new(
        email_address: "user1@example.com",
        role: 3,
        password: "password",
        name: "User 1",
        street_address: "123 Example St",
        city: "Userville",
        state: "State 1",
        zip_code: "12345"
      )
      user1.save
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)

      visit cart_path
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end
  end

end
