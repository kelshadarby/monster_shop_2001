require 'spec_helper'
require 'rails_helper'

RSpec.describe 'As a Admin I have a navbar', type: :feature do
  describe 'where I can click on' do
    before(:all) do
      @user1 = User.new(
        email_address: "user1@example.com",
        role: 3,
        password: "password",
        user_detail: UserDetail.new(
          name: "User 1",
          street_address: "123 Example St",
          city: "Userville",
          state: "State 1",
          zip_code: "12345"
        )
      )
      @user1.save
    end

    before(:each) do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
    end

    it 'home' do
      visit '/register'
      click_on 'Home'
      expect(current_path).to eq(root_path)
    end
    it 'All Merchants' do
      visit '/'
      click_on 'All Merchants'
      expect(current_path).to eq(merchants_path)
    end

    it 'All Items' do
      visit '/'
      click_on 'All Items'
      expect(current_path).to eq(items_path)
    end

    it 'Cart' do
      visit '/'
      expect(page).to_not have_link('Cart')
    end

    it 'Login' do
      visit '/'
      expect(page).to_not have_link('Login')
    end

    it 'Register' do
      visit '/'
      expect(page).to_not have_link('Register')
    end

    it 'Dashboard' do
      visit '/'
      click_on 'Dashboard'
      expect(current_path).to eq(admin_dashboard_path)
    end

    it 'Users' do
      visit '/'
      click_on 'Users'
      expect(current_path).to eq(admin_users_path)
    end

    it 'Profile' do
      visit '/'
      click_on 'Profile'
      expect(current_path).to eq(profile_path)
    end

    it 'Logout' do
      visit '/'
      click_on 'Logout'
      expect(current_path).to eq(root_path)
    end
    after(:all) do
      UserDetail.destroy_all
      User.destroy_all
    end
  end

end
