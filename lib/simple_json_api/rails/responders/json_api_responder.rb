module SimpleJsonApi
  module Rails
    module Responders
      module JsonApiResponder
        def initialize(controller, resources, opts = {})
          puts
          puts controller
          p resources
          p options
          puts
          super
        end

        def to_jsonapi
          resources
        end
      end
    end
  end
end
