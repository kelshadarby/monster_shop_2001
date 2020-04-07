require 'rails_helper'

RSpec.describe "As a user", type: :feature do
  describe 'When I visit' do
    before(:all) do
        @user1 = User.new(
          email_address: "user1@example.com",
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
    
    it 'Can login' do
      visit '/login'
      fill_in "Email Address", with: @user1.email_address
      fill_in "Password", with: @user1.password
      click_button "Login"
      
      expect(page).to have_content("Welcome #{@user1.user_detail.name}")
      expect(current_path).to eq(root_path)
    end
    
    after(:all) do
      UserDetail.destroy_all
      User.destroy_all
    end
  end
end