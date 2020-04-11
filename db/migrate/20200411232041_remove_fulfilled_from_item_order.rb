class RemoveFulfilledFromItemOrder < ActiveRecord::Migration[5.1]
  def change
    remove_column :item_orders, :fulfilled
  end
end
