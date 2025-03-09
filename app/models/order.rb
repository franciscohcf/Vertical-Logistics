class Order < ApplicationRecord
  self.primary_key = 'order_id'

  belongs_to :user, foreign_key: :user_id, primary_key: :user_id, inverse_of: :orders
  has_many :order_products, foreign_key: :order_id, primary_key: :order_id, inverse_of: :order, dependent: :destroy
  has_many :products, through: :order_products

  validates :order_id, presence: true, uniqueness: true
  validates :user_id, presence: true
  validates :date, presence: true

  def total
    order_products.sum(:value)
  end
end
