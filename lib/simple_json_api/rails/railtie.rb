module SimpleJsonApi
  module Rails
    class Railtie < ::Rails::Railtie
      initializer 'simple_json_api' do
        Mime::Type.register 'application/vnd.api+json', :jsonapi

        ActionController::Renderers.add :jsonapi do |object, options|
          fail ArgumentError, 'Missing serializer option' unless options.key? :serializer
          self.content_type ||= Mime::Type.lookup('application/vnd.api+json')
          SimpleJsonApi.render(
            model: object,
            serializer: options[:serializer],
            fields: options[:fields],
            include: options[:include]
          )
        end
      end
    end
  end
end
