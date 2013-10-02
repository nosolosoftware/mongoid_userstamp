require 'rubygems'

begin
  require 'bundler'
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  
  exit e.status_code
end

require 'rake'
require 'jeweler'
require 'yard'

$:.push File.expand_path('../lib', __FILE__)
require 'mongoid/userstamp/version'

Jeweler::Tasks.new do |gem|
  gem.name = 'mongoid_userstamp'
  gem.version = Mongoid::Userstamp::Version::STRING
  gem.homepage = 'https://github.com/tbpro/mongoid_userstamp'
  gem.license = 'MIT'
  gem.summary = %Q{Userstamp for created and updated columns within mongoid}
  gem.email = 'tboerger@tbpro.de'
  gem.authors = ['Thomas Boerger', 'Johnny Shields']
end

Jeweler::RubygemsDotOrgTasks.new
YARD::Rake::YardocTask.new

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
  spec.rspec_opts = '--color --format progress'
end

task default: :spec
