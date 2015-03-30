require 'test_helper'
require 'rails/generators'
require 'rails/generators/test_case'
require 'generators/simple_json_api/resource/resource_generator'

module SimpleJsonApi
  module Generators
    # Tests the generation of the resource template files
    class ResourceGeneratorTest < ::Rails::Generators::TestCase
      tests ResourceGenerator
      destination 'tmp/generators'
      setup :prepare_destination

      def test_generator_runs
        # No error raised? It passes.
        run_generator %w(Animal --namespace=Api::V3)
      end

      def test_bad_model
        assert_raises(SystemExit) do
          run_generator \
            %w(Animal --namespace=Api::V3 --model=AnimalSerializer)
        end
      end

      def teardown
        FileUtils.rm_rf('tmp/generators')
      end
    end
  end
end
