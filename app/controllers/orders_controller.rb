class OrdersController < ApplicationController
  def index
    users_with_orders = User.includes(orders: { order_products: :product }).all

    render json: format_users(users_with_orders)
  end

  private

  def format_users(users)
    users.map do |user|
      {
        user_id: user.user_id,
        name: user.name,
        orders: format_orders(user.orders)
      }
    end
  end

  def format_orders(orders)
    orders.map do |order|
      {
        order_id: order.order_id,
        total: order.total.to_s,
        date: order.date.to_s,
        products: format_products(order.order_products)
      }
    end
  end

  def format_products(order_products)
    order_products.map do |order_product|
      {
        product_id: order_product.product_id,
        value: order_product.value.to_s
      }
    end
  end
end
