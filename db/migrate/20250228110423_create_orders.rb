class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders, id: false, primary_key: :order_id do |t|
      t.integer :order_id, null: false
      t.integer :user_id, null: false
      t.decimal :total, precision: 10, scale: 2, null: false
      t.date :date, null: false
      t.timestamps
    end
    
    add_index :orders, :user_id
  end
end
