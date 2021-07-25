# frozen_string_literal: true

require 'mongoid/userstamp'
require 'mongoid/userstamp/version'
require 'mongoid/userstamp/config/global_config'
require 'mongoid/userstamp/config/model_config'
require 'mongoid/userstamp/config/user_config'
require 'mongoid/userstamp/mixins/user'
require 'mongoid/userstamp/mixins/model'
require 'mongoid/userstamp/railtie' if defined? Rails::Railtie
