class Product < ApplicationRecord
  self.primary_key = 'product_id'

  belongs_to :order, foreign_key: :order_id, primary_key: :order_id, inverse_of: :products

  validates :product_id, presence: true, uniqueness: true
  validates :order_id, presence: true
  validates :value, presence: true, numericality: true
end
