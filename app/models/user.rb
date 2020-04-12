class User < ApplicationRecord
  attr_accessor :password_confirmation

  validates_presence_of :email_address, :name, :street_address, :city, :state, :zip_code
  validates :email_address, uniqueness: {message: "Email is already in use."}

  validates_confirmation_of :password
  validates_presence_of :role

  enum role: {visitor: 0, default: 1, merchant: 2, admin: 3}
  has_secure_password

  has_many :orders
  belongs_to :merchant, optional: true

  def has_orders?
    orders.any?
  end
end
