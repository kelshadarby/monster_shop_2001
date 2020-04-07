require 'rails_helper'

RSpec.describe "As a user", type: :feature do
  describe 'When creating an new user account I' do
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
      @user2 = User.new(
        email_address: "user2@example.com",
        password: "password",
        user_detail: UserDetail.new(
          name: "User 2",
          street_address: "123 Example St",
          city: "Userville",
          state: "State 2",
          zip_code: "12345"
        )
      )
    end
    it "can register a new user with a unique email" do
      visit '/'

      click_link 'Register'

      expect(current_path).to eq '/register'
      fill_in "user_detail_attributes[name]", with: @user1.user_detail.name
      fill_in "user_detail_attributes[street_address]", with: @user1.user_detail.street_address
      fill_in "user_detail_attributes[city]", with: @user1.user_detail.city
      fill_in "user_detail_attributes[state]", with: @user1.user_detail.state
      fill_in "user_detail_attributes[zip_code]", with: @user1.user_detail.zip_code
      fill_in "Email Address", with: @user1.email_address
      fill_in "Password", with: @user1.password
      fill_in "Confirm Password", with: @user1.password
      click_button "Submit"
      
      expect(current_path).to eq '/profile'
      expect(page).to have_content("Registration sucessful! You are now logged in.")
    end
    it "cannot register a user if form is incomplete" do
      visit '/register'

      fill_in "user_detail_attributes[name]", with: @user1.user_detail.name
      # fill_in "user_detail_attributes[street_address]", with: @user1.user_detail.street_address
      fill_in "user_detail_attributes[city]", with: @user1.user_detail.city
      fill_in "user_detail_attributes[state]", with: @user1.user_detail.state
      fill_in "user_detail_attributes[zip_code]", with: @user1.user_detail.zip_code
      fill_in "Email Address", with: @user1.email_address
      fill_in "Password", with: @user1.password
      fill_in "Confirm Password", with: @user1.password
      click_button "Submit"

      expect(page).to have_content("User detail street address can't be blank")

    end
    it "cannot create a user with a duplicate email address" do

      visit '/register'

      fill_in "user_detail_attributes[name]", with: @user1.user_detail.name
      fill_in "user_detail_attributes[street_address]", with: @user1.user_detail.street_address
      fill_in "user_detail_attributes[city]", with: @user1.user_detail.city
      fill_in "user_detail_attributes[state]",  with: @user1.user_detail.state
      fill_in "user_detail_attributes[zip_code]", with: @user1.user_detail.zip_code
      fill_in "Email Address", with: @user1.email_address
      fill_in "Password", with: @user1.password
      fill_in "Confirm Password", with: @user1.password
      click_button "Submit"

      visit '/register'

      @user2.email_address = @user1.email_address
      
      fill_in "user_detail_attributes[name]", with: @user2.user_detail.name
      fill_in "user_detail_attributes[street_address]", with: @user2.user_detail.street_address
      fill_in "user_detail_attributes[city]", with: @user2.user_detail.city
      fill_in "user_detail_attributes[state]", with: @user2.user_detail.state
      fill_in "user_detail_attributes[zip_code]", with: @user2.user_detail.zip_code
      fill_in "Email Address", with: @user2.email_address
      fill_in "Password", with: @user2.password
      fill_in "Confirm Password", with: @user2.password
      click_button "Submit"

      expect(User.all.count).to eq(1)

      expect(find_field("user_detail_attributes[name]").value).to eq(@user2.user_detail.name)
      expect(find_field("user_detail_attributes[street_address]").value).to eq(@user2.user_detail.street_address)
      expect(find_field("user_detail_attributes[city]").value).to eq(@user2.user_detail.city)
      expect(find_field("user_detail_attributes[state]").value).to eq(@user2.user_detail.state)
      expect(find_field("user_detail_attributes[zip_code]").value).to eq(@user2.user_detail.zip_code)
      expect(find_field("Email Address").value).to eq("")
      expect(find_field("Password").value).to eq("")

      expect(page).to have_content("Email is already in use.")
    end

  end
end
