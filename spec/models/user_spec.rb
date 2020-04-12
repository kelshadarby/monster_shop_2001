require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of :email_address }
    it { expect(subject).to validate_uniqueness_of(:email_address).with_message("Email is already in use.") }
    it { should validate_presence_of :password }
    it { should validate_presence_of :role}
    it { should validate_presence_of :name }
    it { should validate_presence_of :street_address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip_code }
  end

  describe 'relationships' do
    it { should have_many :orders}
    it {should belong_to(:merchant).optional}
  end

  describe 'instance methods' do
    it 'has_orders?' do
      user = User.create!(
        email_address: 'user1@example.com',
        password: 'password',
        role: 'default',
        name: 'User 1',
        street_address: '123 Example St',
        city: 'Userville',
        state: 'State 1',
        zip_code: '12345'
      )

      expect(user.has_orders?).to eq(false)

      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)

      expect(user.has_orders?).to eq(true)
    end
  end
end
