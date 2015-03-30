require 'active_support/concern'

module SimpleJsonApi
  module Rails
    module ControllerMethods
      extend ActiveSupport::Concern

      included do
        before_action :simple_json_api_rails_validate_accept_header
      end

      private

      def simple_json_api_rails_validate_accept_header
        head 406 unless request.accepts.include? 'application/vnd.api+json'
        # ap request.accepts
        # ap request.headers.env
        # head 406 if request.headers['HTTP_ACCEPT'].match(//)
      end
    end
  end
end
