require 'rails_helper'

RSpec.describe "As a signed in user, when I visit /profile", type: :feature do
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
    it "shows all of my profile data" do
      visit '/login'
      fill_in "Email Address", with: @user1.email_address
      fill_in "Password", with: @user1.password
      click_button "Login"

      visit "/profile"

      expect(page).to have_content(@user1.email_address)
      expect(page).to have_content(@user1.user_detail.name)
      expect(page).to have_content(@user1.user_detail.street_address)
      expect(page).to have_content(@user1.user_detail.city)
      expect(page).to have_content(@user1.user_detail.state)
      expect(page).to have_content(@user1.user_detail.zip_code)

      expect(page).to have_link("Edit Profile")

    end
    after(:all) do
      UserDetail.destroy_all
      User.destroy_all
    end
  end
# end
