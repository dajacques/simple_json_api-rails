require 'simple_json_api/rails/responders/json_api_responder'

module SimpleJsonApi
  module Rails
    class ApplicationResponder < ActionController::Responder
      include Responders::JsonApiResponder
    end
  end
end
