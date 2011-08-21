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
    end
  end
end