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

  def set_order_packaged
    return false if canceled?
    update(status: "packaged") unless item_orders.where(status: "unfulfilled").any?
  end

  def canceled?
    status == "canceled"
  end
  
  def cancelable?
    status == "pending" || status == "packaged"
  end

  def number_of_items_for_merchant(merchant_id)
    item_orders.joins(:item).where(items: {merchant_id: merchant_id}).sum(:quantity)
  end

  def total_cost_for_merchant(merchant_id)
    item_orders.joins(:item).where(items: {merchant_id: merchant_id}).sum('item_orders.quantity * item_orders.price')
  end

  def ship
    return false if item_orders.where(status: "unfulfilled").any?
    self.update(status: "shipped")
  end
  
end
