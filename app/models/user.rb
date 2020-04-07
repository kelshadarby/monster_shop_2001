class User < ApplicationRecord
  attr_accessor :password_confirmation

  validates_presence_of :email_address
  validates :email_address, uniqueness: {message: "Email is already in use."}
  validates_presence_of :password, require: true
  validates_confirmation_of :password
  validates_presence_of :role

  enum role: {visitor: 0, user: 1, merchant: 2, admin: 3}
  has_secure_password
  
  has_one :user_detail
  accepts_nested_attributes_for :user_detail
end
