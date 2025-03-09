class Product < ApplicationRecord
  self.primary_key = 'product_id'

  has_many :order_products, foreign_key: :product_id, primary_key: :product_id, inverse_of: :product, dependent: :destroy
  has_many :orders, through: :order_products

  validates :product_id, presence: true, uniqueness: true
end
