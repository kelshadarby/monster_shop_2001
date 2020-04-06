require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of :email_address }
    it { should validate_uniqueness_of :email_address }
    it { should validate_presence_of :password_digest }
  end
  describe "relationships" do
    it { should have_one :user_detail }
  end
end
