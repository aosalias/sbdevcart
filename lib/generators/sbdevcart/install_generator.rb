module Sbdevcart
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def migrations
        rake "sbdevcart:install:migrations"
        rake "db:migrate"
      end

      def set_routes
        route "Sbdevcart::Routes.draw(self)"
      end

      def files
        directory "certs", "config/certs", :force => true
        inject_into_file "app/assets/stylesheets/sass.scss", "\n@import 'sbdev_cart';\n", :after => "@import 'sbdev_core';"
      end

      def seeds
        Sbdevcart::Engine.load_seed
      end
    end
  end
end