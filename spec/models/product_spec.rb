require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Schema' do
    it 'has custom primary key product_id' do
      expect(Product.primary_key).to eq('product_id')
    end
  end

  describe 'Validations' do
    before do
      User.create!(user_id: 1, name: 'Paulo')
      Order.create!(order_id: 123, user_id: 1, total: 100.0, date: Time.zone.today)
    end

    it 'is valid with product_id, order_id, and value' do
      expect(Product.new(product_id: 111, order_id: 123, value: 50.0)).to be_valid
    end

    it 'is invalid without a product_id' do
      product = Product.new(order_id: 123, value: 50.0)
      product.valid?
      expect(product.errors[:product_id]).to include("can't be blank")
    end

    it 'is invalid without an order_id' do
      product = Product.new(product_id: 111, value: 50.0)
      product.valid?
      expect(product.errors[:order_id]).to include("can't be blank")
    end

    it 'is invalid without a value' do
      product = Product.new(product_id: 111, order_id: 123)
      product.valid?
      expect(product.errors[:value]).to include("can't be blank")
    end
  end

  describe 'Associations' do
    it 'belongs to an order' do
      association = Product.reflect_on_association(:order)
      expect(association.macro).to eq(:belongs_to)
    end
  end
end
