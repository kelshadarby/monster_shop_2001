require 'spec_helper'
require 'rails_helper'

RSpec.describe 'As a visitor', type: :feature do
  describe 'I have a navbar' do
    it 'where I can click on' do
      visit root_path

      click_on 'All Merchants'
      expect(current_path).to eq(merchants_path)

      click_on 'Home'
      expect(current_path).to eq(root_path)

      click_on 'All Items'
      expect(current_path).to eq(items_path)

      click_on 'Cart'
      expect(current_path).to eq(cart_path)

      click_on 'Login'
      expect(current_path).to eq(login_path)

      click_on 'Register'
      expect(current_path).to eq(register_path)
    end

    it 'I can see a cart indicator' do
      visit root_path
      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit items_path
      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end
    end
  end

  describe 'I am not authorized to visit' do
    it '/admin routes' do
    visit admin_path
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end

    it '/merchant routes' do
      visit merchant_path
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end

    it '/profile' do
      visit '/profile'
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end
  end

end
