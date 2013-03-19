require 'rubygems'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'active_support/all'
require 'mongoid'
require 'mongoid_userstamp'

Mongoid.configure do |config|
  config.connect_to('mongoid_userstamp_test')
end

require 'models'

RSpec.configure do |config|
  config.mock_with :rspec
  config.after :suite do
    Mongoid.purge!
  end
end
