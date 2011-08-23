class OrderItem < ActiveRecord::Base
  attr_accessible :order_id, :quantity, :product_id
  belongs_to :product
  belongs_to :order

  def sub_total
    (quantity.to_i * product.price.to_i)
  end
end
