ENV['RAILS_ENV'] = 'test'

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

require 'simple_json_api/rails'

TEST_OBJECT = Animal.first
TEST_SERIALIZER = AnimalSerializer
