ENV['RAILS_ENV'] = 'test'

require 'simplecov'
if ENV['COVERAGE']
  SimpleCov.start do
    add_filter '/test/'
  end
  SimpleCov.minimum_coverage 90
end

require 'minitest/spec'
require File.expand_path('../../test/dummy/config/environment.rb',  __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path('../../test/dummy/db/migrate', __FILE__)]

require 'rails/test_help'
require 'minitest/rails'

ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load support files
# Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

class ActiveSupport::TestCase
  fixtures :all
end

require 'database_cleaner'
DatabaseCleaner.clean_with :truncation
DatabaseCleaner.strategy = :transaction

class MiniTest::Spec
  before { DatabaseCleaner.start }
  after { DatabaseCleaner.clean }
end

class ActionDispatch::TestResponse
  def json_body
    ActiveSupport::JSON.decode body
  end
end

require 'simple_json_api/rails'

def test_object
  Animal.first
end

def test_serializer
  AnimalSerializer
end
