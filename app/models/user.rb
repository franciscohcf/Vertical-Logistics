class User < ApplicationRecord
  self.primary_key = 'user_id'

  has_many :orders, foreign_key: :user_id, primary_key: :user_id, dependent: :restrict_with_error, inverse_of: :user

  validates :user_id, presence: true, uniqueness: true
  validates :name, presence: true
end
