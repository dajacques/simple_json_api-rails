require 'simple_json_api'

module SimpleJsonApi
  module Rails
    class Engine < ::Rails::Engine
    end
  end
end

require 'simple_json_api/rails/errors'
require 'simple_json_api/rails/railtie' if defined?(Rails)
