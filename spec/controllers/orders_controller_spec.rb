require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  describe 'GET #index' do
    let(:user) { User.create!(user_id: 1, name: 'Test User') }
    let(:order) { Order.create!(order_id: 101, user_id: user.user_id, date: Date.new(2023, 1, 15)) }
    let(:product) { Product.create!(product_id: 201) }
    let(:second_product) { Product.create!(product_id: 202) }

    before do
      OrderProduct.create!(order_id: order.order_id, product_id: product.product_id, value: 100.50)
      OrderProduct.create!(order_id: order.order_id, product_id: second_product.product_id, value: 200.75)
    end

    it 'returns a success response with correct structure' do
      get :index

      expect(response).to be_successful
      json_response = response.parsed_body

      expect(json_response).to be_an(Array)
      expect(json_response.length).to eq(1)

      user_data = json_response.first
      expect(user_data['user_id']).to eq(user.user_id)
      expect(user_data['name']).to eq(user.name)

      order_data = user_data['orders'].first
      expect(order_data['order_id']).to eq(order.order_id)
      expect(order_data['total']).to eq('301.25')
      expect(order_data['date']).to eq(order.date.to_s)

      expect(order_data['products'].length).to eq(2)
      expect(order_data['products'].map { |p| p['value'] }).to include('100.5', '200.75')
    end
  end
end
