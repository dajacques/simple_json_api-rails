source 'https://rubygems.org'

gemspec

version = ENV['RAILS_VERSION'] || '4.1'

case version
when 'master'
  gem 'rails', github: 'rails/rails'
  # Learned from AMS
  # ugh https://github.com/rails/rails/issues/16063#issuecomment-48090125
  gem 'arel', github: 'rails/arel'
  gem 'minitest-rails', github: 'blowmage/minitest-rails', branch: 'rails5'
when '4.1', '4.2'
  gem 'rails', "~> #{version}.0"
  gem 'minitest-rails'
else
  fail GemfileError, "Unsupported Rails version - #{version}"
end

gem 'sqlite3'
gem 'minitest-reporters'
gem 'awesome_print'
gem 'simple_json_api', git: 'https://github.com/ggordon/simple_json_api.git', branch: 'master'

group :test do
  gem 'simplecov'
  gem 'database_cleaner'
end
