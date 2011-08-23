require 'sbdevcore'
require 'sbdevcart'

module Sbdevcart
  class Engine < Rails::Engine
    engine_name "sbdevcart"

    config.dependency_loading = true

    initializer 'sbdevcart.app_controller' do |app|
      APP_CONFIG[:dynamic_pages] << "products" << "orders"
      ActiveSupport.on_load(:action_controller) do
        include Sbdevcart::ApplicationControllerExtensions
      end
    end
  end

  module Routes
    def self.draw(map)
      map.instance_exec do
        resources :orders do
          member do
            post 'paypal'
            get 'ship'
          end
        end
        resources :order_items
        resources :products
        match 'notify' => 'payment_notifications#create', :as => :notify
      end
    end
  end
end
