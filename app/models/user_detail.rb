class UserDetail < ApplicationRecord
  validates_presence_of :name, :street_address, :city, :state, :zip_code
  validates_associated :user
  belongs_to :user
end
