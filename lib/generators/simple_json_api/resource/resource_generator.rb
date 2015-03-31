module SimpleJsonApi
  module Generators
    # Generates the resource template files
    class ResourceGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      argument :name, type: :string, required: true, banner: 'ResourceName'

      class_option :model,
                   desc: 'Model class if different than Resource',
                   type: :string
      class_option :namespace,
                   desc: 'Namespace for the generated files',
                   type: :string
      class_option :controller,
                   desc: 'Base controller for resources',
                   type: :string
      class_option :skip_serializer,
                   desc: "Don't generate a serializer file.",
                   type: :boolean
      class_option :skip_controller,
                   desc: "Don't generate a controller file.",
                   type: :boolean
      class_option :skip_service,
                   desc: "Don't generate a service file.",
                   type: :boolean
      class_option :root_dir,
                   desc: "Root dir for generated code, default: '.'.",
                   type: :string

      def create_resource
        @namespace = options[:namespace]
        @model = options[:model] || class_name
        namespaced_name = [@namespace, class_name].compact.join('::')
        @serializer_name = "#{namespaced_name}Serializer"
        @controller_name = "#{namespaced_name.pluralize}Controller"
        @base_controller = options[:controller] || 'ApplicationController'
        @root_dir = options[:root_dir] || '.'
        file_path = [
          @namespace.try(:underscore),
          class_name.underscore
        ].compact.join('/')

        check_model

        unless options[:skip_serializer]
          template 'serializer_template.rb.erb',
                   "#{@root_dir}/app/serializers/#{file_path}_serializer.rb"
          # TODO: create serializer test
        end

        unless options[:skip_controller]
          template 'controller_template.rb.erb',
                   "#{@root_dir}/app/controllers/#{file_path.pluralize}_controller.rb"
          # TODO: create controller test
        end

        unless options[:skip_service]
          # TODO: create service
          # TODO: create service test
        end
      end

      private

      def check_model
        unless @model.constantize.ancestors.include?(ActiveRecord::Base)
          fail NameError
        end
      rescue NameError
        puts "Error: '#{@model}' is not an AR model"
        exit
      end
    end
  end
end
