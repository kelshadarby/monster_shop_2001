require "rails_helper"

RSpec.describe "As an admin", type: :feature do
  describe 'When I visit a users show page' do
    before(:all) do
      @user = User.create!( email_address: 'user111@example.com', password: 'password', role: 'default', name: 'User 1', street_address: '123 Example St', city: 'Userville', state: 'State 1', zip_code: '12345')
      @user2 = User.create!( email_address: 'user222@example.com', password: 'password', role: 'default', name: 'User 2', street_address: '1234 Example St', city: 'Usertroplois', state: 'State 2', zip_code: '54321')
      @user3 = User.create!( email_address: 'user333@example.com', password: 'password', role: 'default', name: 'User 3', street_address: '12345 Example St', city: 'Userton', state: 'Delaware', zip_code: '00001')
      @admin23 = User.create!( email_address: 'admin45@example.com', password: 'password', role: 3, name: 'admin', street_address: '123 admin St', city: 'adminville', state: 'State 5', zip_code: '54321')
    end

    it "I see everything a user would see on their show page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin23)
      visit "/admin/users"
      click_link(@user.name)

      expect(current_path).to eq("/admin/users/#{@user.id}")
      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.email_address)
      expect(page).to have_content(@user.street_address)
      expect(page).to have_content(@user.city)
      expect(page).to have_content(@user.state)
      expect(page).to have_content(@user.zip_code)
      expect(page).to_not have_link("Edit Profile")
      expect(page).to_not have_link("Change Password")
    end
    after(:all) do
      ItemOrder.destroy_all
      Order.destroy_all
      User.destroy_all
      Merchant.destroy_all
    end
  end
end
