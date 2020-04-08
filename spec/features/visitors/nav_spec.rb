require 'spec_helper'
require 'rails_helper'

RSpec.describe 'As a visitor I have a navbar', type: :feature do
  describe 'where I can click on' do
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
      click_on 'All Merchants'
      expect(current_path).to eq(merchants_path)
    end

    it 'Login' do
      visit '/'
      click_on 'Login'
      expect(current_path).to eq(login_path)
    end
    it 'Register' do
      visit '/'
      click_on 'Register'
      expect(current_path).to eq(register_path)
    end
  end
  
end
