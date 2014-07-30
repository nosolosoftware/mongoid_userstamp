$:.push File.expand_path('../lib', __FILE__)
require 'mongoid/userstamp/version'

Gem::Specification.new do |s|
  s.name        = 'mongoid_userstamp'
  s.version     = Mongoid::Userstamp::VERSION
  s.authors     = ['Thomas Boerger', 'Johnny Shields', 'Bharat Gupta']
  s.homepage    = 'https://github.com/tbpro/mongoid_userstamp'
  s.license     = 'MIT'
  s.summary     = 'Userstamp for Mongoid'
  s.description = 'Userstamp for creator and updater columns using Mongoid'
  s.email       = 'tboerger@tbpro.de'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.post_install_message = File.read('UPGRADING') if File.exists?('UPGRADING')

  s.add_runtime_dependency 'mongoid', '>= 3.0.4'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '>= 3.0.0'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'gem-release'
  s.add_development_dependency 'request_store'
end
