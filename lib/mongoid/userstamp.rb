# -*- encoding : utf-8 -*-

module Mongoid
  module Userstamp
    extend ActiveSupport::Concern

    included do
      cattr_reader :userstamp_key, instance_reader: false
      class_variable_set('@@userstamp_key', :default)
      Mongoid::Userstamp.add(self)
    end

    module ClassMethods
      def mongoid_userstamp(config = :default)
        set_userstamp_key(config.to_sym)
        send(:include, Mongoid::Userstamp::Userstampable)
      end

      def set_userstamp_key(config)
        available = Mongoid::Userstamp.configs.has_key?(config)
        raise ConfigurationNotFoundError.new(config) unless available
        class_variable_set('@@userstamp_key', config)
      end

      def userstamp_config
        Mongoid::Userstamp.configs[userstamp_key]
      end
    end

    class << self
      attr_reader :configs, :timestamped_models

      def config(name = :default, &block)
        @configs ||= { default: Userstamp::Config.new }
        if block_given?
          @configs[name] = Userstamp::Config.new(&block)
        else
          @configs[name] = Userstamp::Config.new
        end
      end

      # DEPRECATED
      def configure(&block)
        warn 'Mongoid::Userstamp.configure is deprecated. Please use Mongoid::Userstamp.config instead'
        config(block)
      end

      def field_opts(opts)
        {type: ::Moped::BSON::ObjectId}.reverse_merge(opts || {})
      end

      def extract_bson_id(value)
        if value.respond_to?(:_id)
          value.try(:_id)
        elsif value.present?
          ::Moped::BSON::ObjectId.from_string(value.to_s)
        else
          nil
        end
      end

      def find_user(user_model, user_id)
        begin
          user_id ? user_model.unscoped.find(user_id) : nil
        rescue Mongoid::Errors::DocumentNotFound => e
          nil
        end
      end

      def add(model)
        @timestamped_models ||= []
        @timestamped_models << model
      end

    end
  end
end
