require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of :email_address }
    it { expect(subject).to validate_uniqueness_of(:email_address).with_message("Email is already in use.") }
    it { should validate_presence_of :password }
    it { should validate_presence_of :role}
  end
  describe "relationships" do
    it { should have_one :user_detail }
  end
end
