require 'rails_helper'

RSpec.describe OrderRecorderService do
  describe '#call' do
    subject(:result) { described_class.new(order_hash).call }

    let(:order_hash) do
      {
        user_id: 99,
        name: 'Junita Jast',
        order_id: 1053,
        product_id: 4,
        value: 747.91,
        date: '2021-10-27'
      }
    end

    context 'when entry is valid' do
      it 'creates a user with correct attributes' do
        expect { result }.to change(User, :count).by(1)

        user = User.find_by(user_id: order_hash[:user_id])
        expect(user).to have_attributes(
          name: order_hash[:name]
        )
      end

      it 'creates an order with correct attributes' do
        expect { result }.to change(Order, :count).by(1)

        order = Order.find_by(order_id: order_hash[:order_id])
        expect(order).to have_attributes(
          user_id: order_hash[:user_id],
          date: Date.parse(order_hash[:date])
        )
      end

      it 'creates a product with correct attributes' do
        expect { result }.to change(Product, :count).by(1)

        product = Product.find_by(product_id: order_hash[:product_id])
        expect(product).not_to be_nil
      end

      it 'creates an order_product relation with correct value' do
        expect { result }.to change(OrderProduct, :count).by(1)

        order_product = OrderProduct.find_by(
          order_id: order_hash[:order_id],
          product_id: order_hash[:product_id]
        )
        expect(order_product).to have_attributes(
          value: order_hash[:value]
        )
      end

      context 'when records already exist' do
        before do
          User.create!(user_id: order_hash[:user_id], name: 'Old Name')
          Order.create!(
            order_id: order_hash[:order_id],
            user_id: order_hash[:user_id],
            date: Date.yesterday
          )
          Product.create!(product_id: order_hash[:product_id])
        end

        it 'does not update existing records' do
          original_user_name = User.find_by(user_id: order_hash[:user_id]).name
          original_date = Order.find_by(order_id: order_hash[:order_id]).date

          expect do
            described_class.new(order_hash).call
          end.not_to change(User, :count)

          expect do
            described_class.new(order_hash).call
          end.not_to change(Order, :count)

          expect do
            described_class.new(order_hash).call
          end.not_to change(Product, :count)

          user = User.find_by(user_id: order_hash[:user_id])
          expect(user.name).to eq(original_user_name)

          order = Order.find_by(order_id: order_hash[:order_id])
          expect(order.date).to eq(original_date)

          order_product = OrderProduct.find_by(
            order_id: order_hash[:order_id],
            product_id: order_hash[:product_id]
          )
          expect(order_product.value).to eq(order_hash[:value])
        end
      end
    end

    context 'when the entry is invalid' do
      context 'when order_hash is nil' do
        let(:order_hash) { nil }

        it 'raises a error' do
          expect { result }.to raise_error(
            ArgumentError,
            'Order data cannot be nil'
          )
        end
      end

      context 'when required fields are missing' do
        let(:order_hash) { { user_id: 99 } }

        it 'raises a validation error' do
          expect { result }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end
end
