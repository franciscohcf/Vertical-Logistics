class OrderRecorderService
  attr_reader :hash

  def initialize(hash)
    @hash = hash
  end

  def call
    raise ArgumentError, 'Order data cannot be nil' if hash.nil?

    begin
      persist_data
      true
    rescue ActiveRecord::RecordInvalid => e
      raise e unless e.message.include?('Order has already been taken')

      Rails.logger.info("Skipping duplicate order: #{hash[:order_id]}")
      true
    end
  end

  private

  def persist_data
    ActiveRecord::Base.transaction do
      user = find_or_create_user
      order = find_or_create_order(user)
      product = find_or_create_product
      find_or_create_order_product(order, product)
    end
  end

  def find_or_create_user
    user = User.find_or_create_by(user_id: hash[:user_id])
    user.update!(name: hash[:name]) if user.new_record?
    user
  end

  def find_or_create_order(user)
    existing_order = Order.find_by(order_id: hash[:order_id])
    return existing_order if existing_order

    Order.create!(
      order_id: hash[:order_id],
      user_id: user.user_id,
      date: Date.parse(hash[:date])
    )
  end

  def find_or_create_product
    Product.find_or_create_by(product_id: hash[:product_id])
  end

  def find_or_create_order_product(order, product)
    order_product = OrderProduct.find_by(
      order_id: order.order_id,
      product_id: product.product_id
    )

    return order_product unless order_product.nil?

    OrderProduct.create!(order_id: order.order_id, product_id: product.product_id, value: hash[:value])
  end
end
