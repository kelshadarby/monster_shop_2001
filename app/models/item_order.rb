class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity

  belongs_to :item
  belongs_to :order

  def subtotal
    price * quantity
  end

  def fulfill
    item.update(inventory: item.inventory - quantity) if unfulfilled?
    update(status: "fulfilled")
    order.update(status: "packaged") if items.where(status: "unfulfilled").any?
  end
  
  def fulfilled?
    return true if status == "fulfilled"
    false
  end

  def unfulfill
    item.update(inventory: item.inventory + quantity) if fulfilled?
    update(status: "unfulfilled")
  end

  def unfulfilled?
    return true if status == "unfulfilled"
    false
  end

  def items
    ItemOrder.where('order_id = ?', order.id)
  end
end
