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

  describe 'GET #show' do
    let(:user) { User.create!(user_id: 1, name: 'Test User') }
    let(:order) { Order.create!(order_id: 101, user_id: user.user_id, date: Date.new(2023, 1, 15)) }
    let(:product) { Product.create!(product_id: 201) }
    let(:second_product) { Product.create!(product_id: 202) }

    before do
      OrderProduct.create!(order_id: order.order_id, product_id: product.product_id, value: 100.50)
      OrderProduct.create!(order_id: order.order_id, product_id: second_product.product_id, value: 200.75)
    end

    context 'when the order exists' do
      it 'returns the order with correct structure' do
        get :show, params: { id: order.order_id }

        expect(response).to be_successful
        json_response = response.parsed_body

        expect(json_response).to be_a(Hash)

        expect(json_response['user_id']).to eq(user.user_id)
        expect(json_response['name']).to eq(user.name)

        order_data = json_response['order']
        expect(order_data['order_id']).to eq(order.order_id)
        expect(order_data['total']).to eq('301.25')
        expect(order_data['date']).to eq(order.date.to_s)

        expect(order_data['products'].length).to eq(2)
        expect(order_data['products'].map { |p| p['value'] }).to include('100.5', '200.75')
      end
    end

    context 'when the order does not exist' do
      it 'returns a not found response' do
        get :show, params: { id: 9999 }

        expect(response).to have_http_status(:not_found)
        json_response = response.parsed_body
        expect(json_response['error']).to eq('Order not found')
      end
    end
  end

  describe 'GET #by_period' do
    let(:first_user) { User.create!(user_id: 1, name: 'First User') }
    let(:second_user) { User.create!(user_id: 2, name: 'Second User') }

    let(:first_product) { Product.create!(product_id: 201) }
    let(:second_product) { Product.create!(product_id: 202) }

    let(:first_june_order) do
      Order.create!(
        order_id: 101,
        user_id: first_user.user_id,
        date: Date.new(2021, 6, 15)
      )
    end

    let(:second_june_order) do
      Order.create!(
        order_id: 102,
        user_id: first_user.user_id,
        date: Date.new(2021, 7, 20)
      )
    end

    let(:august_order) do
      Order.create!(
        order_id: 103,
        user_id: second_user.user_id,
        date: Date.new(2021, 8, 10)
      )
    end

    before do
      OrderProduct.create!(
        order_id: first_june_order.order_id,
        product_id: first_product.product_id,
        value: 100.50
      )
      OrderProduct.create!(
        order_id: second_june_order.order_id,
        product_id: second_product.product_id,
        value: 200.75
      )
    end

    it 'returns orders within a specific date range' do
      get :by_period, params: { start_date: '2021-06-01', end_date: '2021-07-31' }

      expect(response).to be_successful
      json_response = response.parsed_body

      expect(json_response.size).to eq(1)
      expect(json_response.first['user_id']).to eq(first_user.user_id)
      expect(json_response.first['orders'].size).to eq(2)
    end

    it 'handles invalid date ranges' do
      get :by_period, params: { start_date: '2021-12-31', end_date: '2021-01-01' }

      expect(response).to have_http_status(:bad_request)
      expect(response.parsed_body['error']).to eq('Invalid date range')
    end

    it 'returns empty array for no matching orders' do
      get :by_period, params: { start_date: '2022-01-01', end_date: '2022-12-31' }

      expect(response).to be_successful
      expect(response.parsed_body).to be_empty
    end
  end
end
