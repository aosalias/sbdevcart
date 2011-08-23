class CartMailer < ActionMailer::Base
  default :to => APP_CONFIG[:contact_email]
  default :from => APP_CONFIG[:mailer_email]

  def paid(order)
    @order = order
    mail(:subject => "#{order.name} paid for their order.")
  end

  def shipped(order)
    @order = order
    mail(:to => order.email, :reply_to => APP_CONFIG[:contact_email], :subject => "Your order from #{APP_CONFIG[:app_name]} has been shipped.")
  end
end
