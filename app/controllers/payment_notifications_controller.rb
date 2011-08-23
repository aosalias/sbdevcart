class PaymentNotificationsController < ApplicationController
  protect_from_forgery :except => [:create]
  def create
    Order.find(params[:invoice]).payment_notifications.create!(:params => params)
    render :nothing => true
  end
end
