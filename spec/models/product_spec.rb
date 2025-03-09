require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Schema' do
    it 'has custom primary key product_id' do
      expect(Product.primary_key).to eq('product_id')
    end
  end

  describe 'Validations' do
    it 'is valid with just a product_id' do
      expect(Product.new(product_id: 111)).to be_valid
    end

    it 'is invalid without a product_id' do
      product = Product.new
      product.valid?
      expect(product.errors[:product_id]).to include("can't be blank")
    end

    it 'is invalid with a duplicate product_id' do
      Product.create!(product_id: 111)
      duplicate_product = Product.new(product_id: 111)
      duplicate_product.valid?
      expect(duplicate_product.errors[:product_id]).to include('has already been taken')
    end
  end

  describe 'Associations' do
    it 'has many order_products' do
      association = Product.reflect_on_association(:order_products)
      expect(association.macro).to eq(:has_many)
    end

    it 'has many orders through order_products' do
      association = Product.reflect_on_association(:orders)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:order_products)
    end
  end
end
