class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products, id: false, primary_key: :product_id do |t|
      t.integer :product_id, null: false
      t.integer :order_id, null: false
      t.decimal :value, precision: 10, scale: 2, null: false
      t.timestamps
    end
    
    add_index :products, :order_id
  end
end
