class RemoveOrderIdFromProducts < ActiveRecord::Migration[8.0]
  def change
    remove_index :products, :order_id
    remove_column :products, :order_id
  end
end
