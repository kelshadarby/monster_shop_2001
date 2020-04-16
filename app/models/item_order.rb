class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity

  belongs_to :item
  belongs_to :order

  def subtotal
    price * quantity
  end

  def fulfill
    if fillable?
      item.update(inventory: item.inventory - quantity)
      update(status: "fulfilled")
      order.set_order_packaged
      true
    end
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

  def belongs_to_merchant_id?(merchant_id)
    item.merchant.id == merchant_id
  end

  def fillable?
    unfulfilled? && quantity <=item.inventory
  end
end
