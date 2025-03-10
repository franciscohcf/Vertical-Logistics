class OrdersController < ApplicationController
  def index
    users_with_orders = User.includes(orders: { order_products: :product }).all

    render json: format_users(users_with_orders)
  end

  def show
    order = Order.includes(:user, order_products: :product).find_by(order_id: params[:id])

    return render json: { error: 'Order not found' }, status: :not_found if order.nil?

    response = {
      user_id: order.user.user_id,
      name: order.user.name,
      order: format_orders([order]).first
    }

    render json: response
  end

  def by_period
    start_date = params[:start_date]&.to_date
    end_date = params[:end_date]&.to_date

    return render json: { error: 'Invalid date range' }, status: :bad_request unless valid_date_range?(start_date, end_date)

    users_with_orders = User.joins(:orders)
                            .where(orders: { date: start_date..end_date })
                            .includes(orders: { order_products: :product })
                            .distinct

    render json: format_users(users_with_orders)
  end

  private

  def valid_date_range?(start_date, end_date)
    start_date.present? && end_date.present? && start_date <= end_date
  rescue ArgumentError
    false
  end

  def format_users(users)
    users.map do |user|
      {
        user_id: user.user_id,
        name: user.name,
        orders: format_orders(user.orders.select { |order| within_date_range?(order) })
      }
    end
  end

  def within_date_range?(order)
    return true unless params[:start_date] && params[:end_date]

    order_date = order.date
    order_date >= params[:start_date].to_date && order_date <= params[:end_date].to_date
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
