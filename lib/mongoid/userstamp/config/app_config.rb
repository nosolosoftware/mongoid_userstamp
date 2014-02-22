# -*- encoding : utf-8 -*-
module Mongoid
module Userstamp
module Config

  module AppConfig

    attr_accessor :created_by_name
    attr_reader   :created_by_opts
    attr_accessor :updated_by_name
    attr_reader   :updated_by_opts
    attr_reader   :use_request_store
    attr_reader   :user_configs


    def initialize(&block)

      # intialize members
      @created_by_name = :created_by
      @updated_by_name = :updated_by
      @use_request_store = false

      instance_eval(&block) if block_given?

      # initialize user config
      user_config
      @user_config_set = false

    end

    def use_request_store=(value)
      @use_request_store = !!value
    end

    def user_config(&block)
      @user_configs = [] unless @user_config_set
      @user_configs << Mongoid::Userstamp::Config::UserConfig.new(&block)
      @user_config_set = true
    end

    def user_model(value)
      @user_configs.first.model = value
    end

    def user_reader(value)
      @user_configs.first.reader = value
    end

    # @deprecated
    def created_column=(value)
      warn 'Mongoid::Userstamp `created_column` is deprecated as of v0.4.0. Please use `created_by_name` instead.'
      created_by_name = value
    end

    # @deprecated
    def updated_column=(value)
      warn 'Mongoid::Userstamp `created_column` is deprecated as of v0.4.0. Please use `created_by_name` instead.'
      updated_by_name = value
    end
  end
end
end
end


# c.user_model = :'vesper/beauty/merchant_user'
# c.user_reader = :current_bs_merchant_user

# c.user_model  = :'table_solution/merchant_user'
# c.user_reader = :current_merchant_user
