class ChangeItemsImageColumn < ActiveRecord::Migration[5.1]
  def change
    change_column :items, :image, :string, :default => "https://us.123rf.com/450wm/pavelstasevich/pavelstasevich1811/pavelstasevich181101028/112815904-stock-vector-no-image-available-icon-flat-vector-illustration.jpg?ver=6"
  end
end
