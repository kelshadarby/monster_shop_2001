class User < ApplicationRecord
  attr_accessor :password_confirmation

  validates_presence_of :email_address
  validates :email_address, uniqueness: true
  validates_presence_of :password, require: true
  validates_confirmation_of :password

  has_secure_password

  has_one :user_detail
end
