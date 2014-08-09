# -*- encoding : utf-8 -*-

module Mongoid

  module Userstamp
    extend ActiveSupport::Concern

    included do
      Mongoid::Userstamp.add_model_class(self)
    end

    module ClassMethods

      def mongoid_userstamp(opts = {})
        mongoid_userstamp_config(opts)
        self.send(:include, Mongoid::Userstamp::Model) unless self.included_modules.include?(Mongoid::Userstamp::Model)
      end

      def mongoid_userstamp_config(opts = {})
        @mongoid_userstamp_config ||= Mongoid::Userstamp::ModelConfig.new(opts)
      end
    end

    class << self

      def config(&block)
        @config ||= Mongoid::Userstamp::GemConfig.new(&block)
      end

      # @deprecated
      def configure(&block)
        warn 'Mongoid::Userstamp.configure is deprecated. Please use Mongoid::Userstamp.config instead'
        config(&block)
      end

      def current_user(user_class = nil)
        user_class ||= user_classes.first
        store[userstamp_key(user_class)]
      end

      def current_user=(value)
        set_current_user(value)
      end

      # It is better to provide the user class, in case the value is nil.
      def set_current_user(value, user_class = nil)
        user_class ||= value ? value.class : user_classes.first
        store[userstamp_key(user_class)] = value
      end

      def model_classes
        (@model_classes || []).map{|c| c.is_a?(Class) ? c : c.to_s.classify.constantize }
      end

      def add_model_class(model)
        @model_classes ||= []
        @model_classes << model
      end

      def user_classes
        (@user_classes || []).map{|c| c.is_a?(Class) ? c : c.to_s.classify.constantize }
      end

      def add_user_class(user)
        @user_classes ||= []
        @user_classes << user
      end

      def userstamp_key(model)
        "mongoid_userstamp/#{model.to_s.underscore}".to_sym
      end

      def store
        defined?(RequestStore) ? RequestStore.store : Thread.current
      end
    end
  end
end
