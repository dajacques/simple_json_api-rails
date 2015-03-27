require 'simple_json_api'

module SimpleJsonApi
  module Rails
    class Engine < ::Rails::Engine
    end
  end
end

require 'simple_json_api/rails/controller_methods'

require 'simple_json_api/rails/railtie' if defined?(Rails)
