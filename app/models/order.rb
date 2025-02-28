class Order < ApplicationRecord
  self.primary_key = 'order_id'

  belongs_to :user, foreign_key: :user_id, primary_key: :user_id, inverse_of: :orders

  validates :order_id, presence: true, uniqueness: true
  validates :user_id, presence: true
  validates :total, presence: true, numericality: true
  validates :date, presence: true
end
