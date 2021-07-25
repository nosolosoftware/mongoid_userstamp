# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __dir__)

require 'mongoid'
require 'mongoid_userstamp'
Dir.glob('support/**/*.rb', base: __dir__).sort.each {|f| require(f) }

Mongoid.configure do |config|
  config.connect_to 'mongoid_userstamp_test'
end

RSpec.configure do |config|
  config.mock_with :rspec

  config.after :suite do
    Mongoid.purge!
  end
end
