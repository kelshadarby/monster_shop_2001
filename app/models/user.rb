class User < ApplicationRecord
  validates_presence_of :email_address
  validates :email_address, uniqueness: true
  validates_presence_of :password_digest

  has_secure_password

  has_one :user_detail
end
