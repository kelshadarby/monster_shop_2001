require 'rails_helper'

RSpec.describe "As a visitor", type: :feature do
  describe 'When I visit /login' do
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

      expect(page).to have_content("Logged in as #{@user1.user_detail.name}")
    end

    it " default users redirect to their profile page upon login" do
      visit '/login'
      fill_in "Email Address", with: @user1.email_address
      fill_in "Password", with: @user1.password
      click_button "Login"

      expect(page).to have_content("Logged in as #{@user1.user_detail.name}")
      expect(current_path).to eq("/profile")
    end

    it "merchants redirect to merhcant dashboard upon login" do
      @user2 = User.new(
        email_address: "user2@example.com",
        password: "password",
        role: 2,
        user_detail: UserDetail.new(
          name: "User 1",
          street_address: "123 Example St",
          city: "Userville",
          state: "State 1",
          zip_code: "12345"
        )
      )
      @user2.save

      visit '/login'
      fill_in "Email Address", with: @user2.email_address
      fill_in "Password", with: @user2.password
      click_button "Login"

      expect(page).to have_content("Logged in as #{@user2.user_detail.name}")
      expect(current_path).to eq("/merchant/dashboard")
    end

    it "admin redirect to admin dashboard upon login" do
      @user3 = User.new(
        email_address: "user3@example.com",
        password: "password",
        role: 3,
        user_detail: UserDetail.new(
          name: "User 1",
          street_address: "123 Example St",
          city: "Userville",
          state: "State 1",
          zip_code: "12345"
        )
      )
      @user3.save

      visit '/login'
      fill_in "Email Address", with: @user3.email_address
      fill_in "Password", with: @user3.password
      click_button "Login"

      expect(page).to have_content("Logged in as #{@user3.user_detail.name}")
      expect(current_path).to eq("/admin/dashboard")
    end

    it "will not log in with bad credentials" do
      fake_email = "youknowit@example.com"
      fake_password = "hackerman"

      visit '/login'
      fill_in "Email Address", with: fake_email
      fill_in "Password", with: fake_password
      click_button "Login"

      expect(page).to_not have_content("Welcome")
      expect(page).to have_content("Invalid Credentials")
      expect(current_path).to eq("/login")
    end

    it "users already logged in are redirected to their profile" do
        visit '/login'
        fill_in "Email Address", with: @user1.email_address
        fill_in "Password", with: @user1.password
        click_button "Login"

        expect(page).to have_content("Logged in as #{@user1.user_detail.name}")
        expect(current_path).to eq("/profile")

        visit "/login"
        expect(current_path).to eq("/profile")
    end

    it "merchents already logged in are redirected to their dashboard" do
      @user2 = User.new(
        email_address: "user2@example.com",
        password: "password",
        role: 2,
        user_detail: UserDetail.new(
          name: "User 1",
          street_address: "123 Example St",
          city: "Userville",
          state: "State 1",
          zip_code: "12345"
        )
      )
      @user2.save

      visit '/login'
      fill_in "Email Address", with: @user2.email_address
      fill_in "Password", with: @user2.password
      click_button "Login"

      expect(current_path).to eq("/merchant/dashboard")
      visit '/login'
      expect(current_path).to eq("/merchant/dashboard")
    end

    it "admin already logged in are redirected to their dashboard" do
      @user3 = User.new(
        email_address: "user3@example.com",
        password: "password",
        role: 3,
        user_detail: UserDetail.new(
          name: "User 1",
          street_address: "123 Example St",
          city: "Userville",
          state: "State 1",
          zip_code: "12345"
        )
      )
      @user3.save

      visit '/login'
      fill_in "Email Address", with: @user3.email_address
      fill_in "Password", with: @user3.password
      click_button "Login"

      expect(current_path).to eq("/admin/dashboard")
      visit "/login"
      expect(current_path).to eq("/admin/dashboard")
    end

    after(:all) do
      UserDetail.destroy_all
      User.destroy_all
    end
  end
end
