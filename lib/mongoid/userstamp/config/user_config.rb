# -*- encoding : utf-8 -*-
module Mongoid
module Userstamp
module Config

  module UserConfig

    attr_writer   :model
    attr_accessor :reader

    def initialize(&block)
      @model  = :user
      @reader = :current_user
      instance_eval(&block) if block_given?
    end

    def model
      @model.to_s.classify.constantize
    end
  end
end
end
end
