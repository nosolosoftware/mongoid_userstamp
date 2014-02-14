# -*- encoding : utf-8 -*-
require 'rubygems'

$:.push File.expand_path('../../lib', __FILE__)

require 'active_support/all'
require 'mongoid'
require 'mongoid_userstamp'

%w(config admin user book post).each do |file_name|
  require "support/#{file_name}"
end

Mongoid.configure do |config|
  config.connect_to(
    'mongoid_userstamp_test'
  )
end

RSpec.configure do |config|
  config.mock_with :rspec
  
  config.after :suite do
    Mongoid.purge!
  end
end
