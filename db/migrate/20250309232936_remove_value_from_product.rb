class RemoveValueFromProduct < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :value
  end
end
