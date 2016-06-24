# -*- encoding : utf-8 -*-

require 'mongoid/userstamp'
require 'mongoid/userstamp/version'
require 'mongoid/userstamp/config/gem_config'
require 'mongoid/userstamp/config/model_config'
require 'mongoid/userstamp/config/user_config'
require 'mongoid/userstamp/mixins/user_mixin'
require 'mongoid/userstamp/mixins/model_mixin'
require 'mongoid/userstamp/railtie' if defined? Rails
