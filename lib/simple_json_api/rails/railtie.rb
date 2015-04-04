require 'simple_json_api/rails/json_api_params_parser'

module SimpleJsonApi
  module Rails
    class Railtie < ::Rails::Railtie
      initializer 'simple_json_api' do |app|
        app.middleware.insert_after ActionDispatch::ParamsParser, SimpleJsonApi::Rails::JsonApiParamsParser

        Mime::Type.register 'application/vnd.api+json', :jsonapi

        ActionController::Renderers.add :jsonapi do |object, options|
          fail ArgumentError, 'Missing serializer option' unless options.key? :serializer
          self.content_type ||= Mime::Type.lookup('application/vnd.api+json')
          self.status = 200
          SimpleJsonApi.render(
            model: object,
            serializer: options[:serializer],
            fields: options[:fields],
            include: options[:include]
          )
        end

        ActionController::Renderers.add :jsonapi_error do |object, options|
          error = if object.is_a? SimpleJsonApi::Rails::Error
            object
          else
            SimpleJsonApi::Rails::Error.new object.to_s
          end
          self.content_type ||= Mime::Type.lookup('application/vnd.api+json')
          self.status = error.status
          {
            errors: [
              {
                status: error.status.to_s,
                detail: error.message
              }
            ]
          }.to_json
        end

      end
    end
  end
end
