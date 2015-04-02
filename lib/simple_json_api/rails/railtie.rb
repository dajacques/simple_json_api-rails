module SimpleJsonApi
  module Rails
    class Railtie < ::Rails::Railtie
      initializer 'simple_json_api' do
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
          object = SimpleJsonApi::Rails::Error.new(object.to_s) unless
            object.is_a? SimpleJsonApi::Rails::Error
          self.content_type ||= Mime::Type.lookup('application/vnd.api+json')
          self.status = object.status
          {
            errors: [
              {
                status: object.status.to_s,
                detail: object.message
              }
            ]
          }.to_json
        end
      end
    end
  end
end
