$:.push File.expand_path('../lib', __FILE__)

require 'simple_json_api/rails/version'

Gem::Specification.new do |s|
  s.name        = 'simple_json_api-rails'
  s.version     = SimpleJsonApi::Rails::VERSION
  s.authors     = ['David Jacques']
  s.email       = ['david@twojs.org']
  s.homepage    = ''
  s.summary     = 'SimpleJsonApi configuration for Rails apps'
  s.license     = 'MIT'

  s.files = Dir["{app,config,db,lib}/**/*", 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'simple_json_api', '~> 0.0.4'
  s.add_dependency 'rails', '>= 4.1'
end
