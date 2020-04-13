class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_items
    item_orders.sum('quantity')
  end
  
  def cancel
    return false if status == "shipped"
    item_orders.each do |item_order|
      item_order.unfulfill
    end
    self.update(status: "canceled")
  end

  def ship
    return false if item_orders.where(status: "unfulfilled").any?
    self.update(status: "shipped")
  end
  
end
