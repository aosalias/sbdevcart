require 'sbdevcore'
require 'sbdevcart'

module Sbdevcart
  class Engine < Rails::Engine
    engine_name "sbdevcart"
  end

  module Routes
    def self.draw(map)
      map.instance_exec do
      end
    end
  end
end
