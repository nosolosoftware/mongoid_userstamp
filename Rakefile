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
  gem.homepage = 'https://github.com/Langwhich/mongoid_userstamp'
  gem.license = 'MIT'
  gem.summary = %Q{Userstamp for created and updated columns within mongoid}
  gem.email = 'thomas.boerger@langwhich.com'
  gem.authors = ['Thomas Boerger', 'Tim Rudat']
end

Jeweler::RubygemsDotOrgTasks.new
YARD::Rake::YardocTask.new

task :default => :version

