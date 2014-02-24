# -*- encoding : utf-8 -*-

module Mongoid
module Userstamp

  class ModelConfig

    def initialize(opts = {})
      @user_model   = opts.delete(:user_model)
      @created_name = opts.delete(:created_name)
      @updated_name = opts.delete(:updated_name)
    end

    def user_model
      @user_model || Mongoid::Userstamp.user_classes.first
    end

    def created_name
      @created_name || Mongoid::Userstamp.config.created_name
    end

    def updated_name
      @updated_name || Mongoid::Userstamp.config.updated_name
    end
  end
end
end
