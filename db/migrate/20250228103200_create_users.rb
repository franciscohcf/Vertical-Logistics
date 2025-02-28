class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: false, primary_key: :user_id do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
