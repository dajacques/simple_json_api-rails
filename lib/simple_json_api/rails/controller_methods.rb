require 'active_support/concern'

module SimpleJsonApi
  module Rails
    module ControllerMethods
      extend ActiveSupport::Concern

      JSON_API_MIME_TYPE = 'application/vnd.api+json'
      JSON_API_EXT_REGEX = Regexp.new(Regexp.quote(JSON_API_MIME_TYPE) + ';[^,]*\s*ext=\w+')

      included do
        before_action :simple_json_api_rails_validate_accept_header
      end

      private

      def simple_json_api_rails_validate_accept_header
        head 406 unless request.accepts.include? JSON_API_MIME_TYPE
        head 406 if request.headers['HTTP_ACCEPT'].try(:match, JSON_API_EXT_REGEX)
      end
    end
  end
end
