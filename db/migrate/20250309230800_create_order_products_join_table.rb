class CreateOrderProductsJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_table :order_products, id: false do |t|
      t.integer :order_id, null: false
      t.integer :product_id, null: false
      t.decimal :value, precision: 10, scale: 2, null: false
      t.timestamps
    end
    
    add_index :order_products, [:order_id, :product_id], unique: true
    add_index :order_products, :product_id
  end
end
