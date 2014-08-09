# -*- encoding : utf-8 -*-

module Mongoid
module Userstamp

  class GemConfig

    attr_accessor :created_name
    attr_accessor :updated_name
    attr_accessor :user_reader

    def initialize(&block)
      @created_name = :created_by
      @updated_name = :updated_by
      @user_reader  = :current_user

      instance_eval(&block) if block_given?
    end

    # @deprecated
    def user_model=(value)
      warn 'Mongoid::Userstamp `user_model` config is removed as of v0.4.0. If using a model named other than `User`, please include `Mongoid::Userstamp::User` in your user model instead.'
    end

    # @deprecated
    def created_column=(value)
      warn 'Mongoid::Userstamp `created_column` is deprecated as of v0.4.0. Please use `created_name` instead.'
      @created_name = value
    end

    # @deprecated
    def updated_column=(value)
      warn 'Mongoid::Userstamp `created_column` is deprecated as of v0.4.0. Please use `created_name` instead.'
      @updated_name = value
    end
  end
end
end
