class OrderRecorderService
  attr_reader :hash

  def initialize(hash)
    @hash = hash
  end

  def call
    raise ArgumentError, 'Order data cannot be nil' if hash.nil?

    persist_data
  end

  private

  def persist_data
    ActiveRecord::Base.transaction do
      user = find_or_create_user
      order = find_or_create_order(user)
      product = find_or_create_product
      create_or_update_order_product(order, product)
    end
  end

  def find_or_create_user
    user = User.find_or_create_by(user_id: hash[:user_id])

    user.update!(name: hash[:name]) if user.new_record?

    user
  end

  def find_or_create_order(user)
    order = Order.find_or_create_by(
      order_id: hash[:order_id],
      user_id: user.user_id
    )

    order.update!(date: Date.parse(hash[:date])) if order.new_record?

    order
  end

  def find_or_create_product
    Product.find_or_create_by(product_id: hash[:product_id])
  end

  def create_or_update_order_product(order, product)
    order_product = OrderProduct.find_or_initialize_by(
      order_id: order.order_id,
      product_id: product.product_id
    )

    order_product.value = hash[:value]
    order_product.save!

    order_product
  end
end
