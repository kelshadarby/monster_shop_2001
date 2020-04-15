require "rails_helper"

RSpec.describe "As an admin", type: :feature do
  describe 'When I visit /users' do
    before(:all) do
      @user = User.create!( email_address: 'user1@example.com', password: 'password', role: 'default', name: 'User 1', street_address: '123 Example St', city: 'Userville', state: 'State 1', zip_code: '12345')
      @user2 = User.create!( email_address: 'user2@example.com', password: 'password', role: 'default', name: 'User 2', street_address: '1234 Example St', city: 'Usertroplois', state: 'State 2', zip_code: '54321')
      @user3 = User.create!( email_address: 'user3@example.com', password: 'password', role: 'default', name: 'User 3', street_address: '12345 Example St', city: 'Userton', state: 'Delaware', zip_code: '00001')
      @admin23 = User.create!( email_address: 'admin@example.com', password: 'password', role: 3, name: 'admin', street_address: '123 admin St', city: 'adminville', state: 'State 5', zip_code: '54321')
    end

    it "I see all users in they system, their names are links to user show pages" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin23)
      visit "/admin/users"

      expect(page).to have_link(@user.name, :href => "/admin/users/#{@user.id}")
      expect(page).to have_link(@user2.name, :href => "/admin/users/#{@user2.id}")
      expect(page).to have_link(@user3.name, :href => "/admin/users/#{@user3.id}")
    end

    it "I see all users roles and the date they registered" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin23)
      visit "/admin/users"

      expect(page).to have_content(@user.role)
      expect(page).to have_content(@user2.role)
      expect(page).to have_content(@user3.role)
      expect(page).to have_content(@user3.created_at)
      expect(page).to have_content(@user2.created_at)
      expect(page).to have_content(@user.created_at)
    end

    after(:all) do
      ItemOrder.destroy_all
      Order.destroy_all
      User.destroy_all
      Merchant.destroy_all
    end
  end
end
