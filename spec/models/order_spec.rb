require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'Schema' do
    it 'has custom primary key order_id' do
      expect(Order.primary_key).to eq('order_id')
    end
  end

  describe 'Validations' do
    before do
      User.create!(user_id: 1, name: 'Paulo')
    end

    context 'when it is valid' do
      it 'has order_id, user_id, date and total' do
        order = Order.create!(order_id: 123, user_id: 1, date: Time.zone.today)

        Product.create!(product_id: 111)
        Product.create!(product_id: 112)
        OrderProduct.create!(order_id: 123, product_id: 111, value: 50.0)
        OrderProduct.create!(order_id: 123, product_id: 112, value: 100.0)

        expect(order.total).to eq 150.0
        expect(order).to be_valid
      end
    end

    context 'when it is invalid' do
      it 'without an order_id' do
        order = Order.new(user_id: 1, date: Time.zone.today)
        order.valid?

        expect(order.errors[:order_id]).to include("can't be blank")
      end

      it 'without a user_id' do
        order = Order.new(order_id: 123, date: Time.zone.today)
        order.valid?

        expect(order.errors[:user_id]).to include("can't be blank")
      end

      it 'without a date' do
        order = Order.new(order_id: 123, user_id: 1)
        order.valid?

        expect(order.errors[:date]).to include("can't be blank")
      end

      it 'with a duplicate order_id' do
        Order.create!(order_id: 123, user_id: 1, date: Time.zone.today)
        duplicate_order = Order.new(order_id: 123, user_id: 1, date: Time.zone.today)
        duplicate_order.valid?

        expect(duplicate_order.errors[:order_id]).to include('has already been taken')
      end
    end
  end

  describe 'Associations' do
    it 'belongs to a user' do
      association = Order.reflect_on_association(:user)

      expect(association.macro).to eq(:belongs_to)
      expect(association.foreign_key).to eq('user_id')
    end

    it 'has many order_products' do
      expect(Order.reflect_on_association(:order_products).macro).to eq(:has_many)
    end

    it 'has many products through order_products' do
      association = Order.reflect_on_association(:products)

      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:order_products)
    end
  end
end
