class ChangeItemsColumnDefaultValue < ActiveRecord::Migration[5.1]
  def change
    change_column :items, :image, :string, :default => "https://upload.wikimedia.org/wikipedia/commons/1/15/No_image_available_600_x_450.svg"
  end
end
