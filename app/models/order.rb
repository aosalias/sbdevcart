class Order < ActiveRecord::Base
  include AASM
  attr_accessible :email, :state, :purchased_at

  cattr_reader :per_page
  @@per_page = 10

  has_many :order_items
  has_many :products, :through => :order_items
  has_many :payment_notifications

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :allow_nil => true

  def total
    order_items.map(&:sub_total).inject(:+)
  end

  def payment_notification
    payment_notifications.last
  end

  def empty?
    order_items.empty?
  end
  
  def name
    return "Unknown" unless payment_notification
    notification = payment_notification.params
    notification[:first_name] + " " + notification[:last_name] rescue "Unknown"
  end

  def address
    return "Unknown" unless payment_notification
    notification = payment_notification.params
    [notification[:address_street], notification[:address_city], notification[:address_state], notification[:address_zip], notification[:address_country]].join(" ") rescue "Unknown"
  end

  def paypal_url(return_url, notify_url)
    values = {
      :business => APP_CONFIG[:paypal_email],
      :cmd => "_cart",
      :upload => 1,
      :return => return_url,
      :invoice => id,
      :notify => notify_url,
      :cert_id => APP_CONFIG[:paypal_cert_id],
      :no_shipping => 2
    }  
    order_items.each_with_index do |order_item, index|
      values.merge!({
        "amount_#{index + 1}" => order_item.product.price,
        "item_name_#{index + 1}" => order_item.product.name,
        "item_number_#{index + 1}" => order_item.product.id,
        "quantity_#{index + 1}" => order_item.quantity
      })  
    end
    logger.info values.inspect
    APP_CONFIG[:paypal_url] + {:encrypted => encrypt_for_paypal(values), :cmd => "_s-xclick"}.to_query
  end

  PAYPAL_CERT_PEM = File.read("#{Rails.root}/certs/#{Rails.env.to_s}/paypal_cert.pem")
  APP_CERT_PEM = File.read("#{Rails.root}/certs/#{Rails.env.to_s}/app_cert.pem")
  APP_KEY_PEM = File.read("#{Rails.root}/certs/#{Rails.env.to_s}/app_key.pem")

  def encrypt_for_paypal(values)
    signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(APP_CERT_PEM), OpenSSL::PKey::RSA.new(APP_KEY_PEM, ''), values.map { |k, v| "#{k}=#{v}" }.join("\n"), [], OpenSSL::PKCS7::BINARY)
    OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(PAYPAL_CERT_PEM)], signed.to_der, OpenSSL::Cipher::Cipher::new("DES3"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
  end

  aasm_column :state
  aasm_initial_state :open
  aasm_state :open
  aasm_state :ordered, :enter => [:timestamp]
  aasm_state :paid, :enter => :send_paid
  aasm_state :shipped, :enter => :send_shipped
  aasm_state :payment_failed

  aasm_event :ordered do
    transitions :to => :ordered, :from => [:open, :payment_failed]
  end

  aasm_event :paid do
    transitions :to => :paid, :from => [:ordered]
  end

  aasm_event :payment_failed do
    transitions :to => :payment_failed, :from => [:ordered]
  end

  aasm_event :shipped do
    transitions :to => :shipped, :from => [:paid]
  end

  def timestamp
    update_attribute(:purchased_at, Time.now)
  end

  def send_paid
    CartMailer.paid(self).deliver
  end

  def send_shipped
    CartMailer.shipped(self).deliver
  end
end
