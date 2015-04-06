require 'active_support/concern'

module SimpleJsonApi
  module Rails
    module ControllerMethods
      extend ActiveSupport::Concern

      JSON_API_MIME_TYPE = 'application/vnd.api+json'
      JSON_API_EXT_REGEX = Regexp.new(Regexp.quote(JSON_API_MIME_TYPE) + ';[^,]*\s*ext=\w+')

      included do
        before_action :_sjar_validate_mime_type_headers
        # rescue_from ActiveRecord::RecordNotFound, with: :_sjar_handle_record_not_found
        rescue_from SimpleJsonApi::Rails::Error, with: :_sjar_handle_error
      end

      private

      def _sjar_validate_mime_type_headers
        fail(NotAcceptableError, "Accept header must include '#{JSON_API_MIME_TYPE}'") unless
          request.accepts.include? JSON_API_MIME_TYPE
        fail(NotAcceptableError, 'Accept header included unsupported extensions') if
          request.headers['HTTP_ACCEPT'].try(:match, JSON_API_EXT_REGEX)
        fail(UnsupportedMediaTypeError, 'Unsupported Content-Type') if
          request.content_type.try(:!=, JSON_API_MIME_TYPE)
      end

      # def _sjar_handle_record_not_found(error)
      #   _sjar_render_exception SimpleJsonApi::Rails::NotFoundError.new(error.message)
      # end

      def _sjar_handle_error(error)
        _sjar_render_exception error
      end

      def _sjar_render_exception(error)
        render jsonapi_error: error
      end
    end
  end
end
