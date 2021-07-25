# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'mongoid/userstamp/version'

Gem::Specification.new do |gem|
  gem.name        = 'mongoid_userstamp'
  gem.version     = Mongoid::Userstamp::VERSION
  gem.authors     = ['Johnny Shields', 'Thomas Boerger', 'Bharat Gupta']
  gem.homepage    = 'https://github.com/tablecheck/mongoid_userstamp'
  gem.license     = 'MIT'
  gem.summary     = 'Userstamp for Mongoid'
  gem.description = 'Userstamp for creator and updater columns using Mongoid'
  gem.email       = 'info@tablecheck.com'

  gem.files         = Dir.glob('lib/**/*') + %w[LICENSE README.md]
  gem.test_files    = Dir.glob('spec/**/*')
  gem.require_paths = ['lib']

  gem.post_install_message = File.read('UPGRADING') if File.exist?('UPGRADING')

  gem.add_runtime_dependency 'mongoid', '>= 7'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'request_store'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rubocop', '>= 1.18.4'
  gem.add_development_dependency 'rubocop-rake'
  gem.add_development_dependency 'rubocop-rspec'
  gem.add_development_dependency 'yard'
end
