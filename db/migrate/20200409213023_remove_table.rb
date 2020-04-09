class RemoveTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :user_details
  end
end
