require 'active_support/core_ext/hash/conversions'
require 'action_dispatch/http/request'
require 'active_support/core_ext/hash/indifferent_access'

module SimpleJsonApi
  module Rails
    class JsonApiParamsParser

      def initialize(app)
        @app = app
      end

      def call(env)
        if params = parse_formatted_parameters(env)
          env["action_dispatch.request.request_parameters"] = params
        end

        @app.call(env)
      end

      private

      def parse_formatted_parameters(env)
        request = ActionDispatch::Request.new(env)

        return false if request.content_length.zero?

        mime_type = request.content_mime_type
        logger(env).debug mime_type.inspect

        if mime_type == Mime::JSONAPI
          data = ActiveSupport::JSON.decode(request.raw_post)
          data = { :_jsonapi => data } unless data.is_a?(Hash)
          ActionDispatch::Request::Utils.deep_munge(data).with_indifferent_access
        else
          false
        end
      rescue Exception => e # JSON or Ruby code block errors
        logger(env).debug "Error occurred while parsing request parameters.\nContents:\n\n#{request.raw_post}"

        raise ActionDispatch::ParamsParser::ParseError.new(e.message, e)
      end

      def logger(env)
        env['action_dispatch.logger'] || ActiveSupport::Logger.new($stderr)
      end
    end
  end
end

