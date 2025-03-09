class Order < ApplicationRecord
  self.primary_key = 'order_id'

  belongs_to :user, foreign_key: :user_id, primary_key: :user_id, inverse_of: :orders
  has_many :products, foreign_key: :order_id, primary_key: :order_id, inverse_of: :order, dependent: :destroy

  validates :order_id, presence: true, uniqueness: true
  validates :user_id, presence: true
  validates :date, presence: true

  def total
    products.sum(:value)
  end
end
