require 'active_support/concern'

module SimpleJsonApi
  module Rails
    module ControllerMethods
      extend ActiveSupport::Concern

      JSON_API_MIME_TYPE = 'application/vnd.api+json'
      JSON_API_EXT_REGEX = Regexp.new(Regexp.quote(JSON_API_MIME_TYPE) + ';[^,]*\s*ext=\w+')

      included do
        before_action :simple_json_api_rails_validate_mime_type_headers
        rescue_from SimpleJsonApi::Rails::BaseError, with: :simple_json_api_rails_handle_base_error
      end

      private

      def simple_json_api_rails_validate_mime_type_headers
        fail(NotAcceptableError, "Accept header should include '#{JSON_API_MIME_TYPE}'") unless
          request.accepts.include? JSON_API_MIME_TYPE
        fail(NotAcceptableError, 'Accept header included unsupported extensions') if
          request.headers['HTTP_ACCEPT'].try(:match, JSON_API_EXT_REGEX)
        fail(UnsupportedMediaTypeError, 'Unsupported Content-Type') if
          request.content_type.try(:!=, JSON_API_MIME_TYPE)
      end

      def simple_json_api_rails_handle_base_error(error)
        render jsonapi_error: error
      end
    end
  end
end
