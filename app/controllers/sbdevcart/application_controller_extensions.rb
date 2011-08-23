module Sbdevcart
  module ApplicationControllerExtensions
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.before_filter :current_order
    end
    module InstanceMethods
      def current_order
        if session[:order_id]
          @order ||= Order.find_by_id(session[:order_id])
          session[:order_id] = nil unless((@order.open? || @order.payment_failed?) rescue false)
        end
        if session[:order_id].nil?
          @order = Order.create!
          session[:order_id] = @order.id
        end
        @order
      end
    end
  end
end
