class OrderProduct < ApplicationRecord
  self.table_name = 'order_products'

  belongs_to :order, foreign_key: :order_id, primary_key: :order_id, inverse_of: :order_products
  belongs_to :product, foreign_key: :product_id, primary_key: :product_id, inverse_of: :order_products

  validates :order_id, presence: true
  validates :product_id, presence: true
  validates :value, presence: true, numericality: true
  validates :order_id, uniqueness: { scope: :product_id }
end
