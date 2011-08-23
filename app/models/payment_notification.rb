class PaymentNotification < ActiveRecord::Base
  belongs_to :order
  serialize :params
  after_create :mark_order_as_purchased

  def status
    params[:payment_status]
  end
  private
  def mark_order_as_purchased
    if status == "Completed" #&& params[:secret] == APP_CONFIG[:paypal_secret]
      order.paid!
    else
      order.payment_failed!
    end
  end
end
