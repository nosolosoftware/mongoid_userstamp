# -*- encoding : utf-8 -*-
module Mongoid
  module Userstamp
    extend ActiveSupport::Concern

    autoload :Version, 'mongoid/userstamp/version'
    autoload :Railtie, 'mongoid/userstamp/railtie'
    autoload :Config, 'mongoid/userstamp/config'
    autoload :User, 'mongoid/userstamp/user'

    included do
      field Userstamp.config.updated_column, Userstamp.field_opts(Userstamp.config.updated_column_opts)
      field Userstamp.config.created_column, Userstamp.field_opts(Userstamp.config.created_column_opts)

      before_save :set_updater
      before_create :set_creator

      define_method Userstamp.config.updated_accessor do
        Userstamp.find_user self.send(Userstamp.config.updated_column)
      end

      define_method Userstamp.config.created_accessor do
        Userstamp.find_user self.send(Userstamp.config.created_column)
      end

      define_method "#{Userstamp.config.updated_accessor}=" do |user|
        self.send("#{Userstamp.config.updated_column}=", Userstamp.extract_bson_id(user))
      end

      define_method "#{Userstamp.config.created_accessor}=" do |user|
        self.send("#{Userstamp.config.created_column}=", Userstamp.extract_bson_id(user))
      end

      protected

      def set_updater
        return if !Userstamp.has_current_user?
        self.send("#{Userstamp.config.updated_accessor}=", Userstamp.current_user)
      end

      def set_creator
        return if !Userstamp.has_current_user? || self.send(Userstamp.config.created_column)
        self.send("#{Userstamp.config.created_accessor}=", Userstamp.current_user)
      end
    end

    class << self
      def config(&block)
        if block_given?
          @@config = Userstamp::Config.new(&block)
        else
          @@config ||= Userstamp::Config.new
        end
      end
      alias :configure :config # DEPRECATED

      def field_opts(opts)
        {type: ::Moped::BSON::ObjectId}.reverse_merge(opts || {})
      end

      def has_current_user?
        config.user_model.respond_to?(:current)
      end

      def current_user
        config.user_model.try(:current)
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

      def find_user(user_id)
        begin
          user_id ? Userstamp.config.user_model.unscoped.find(user_id) : nil
        rescue Mongoid::Errors::DocumentNotFound => e
          nil
        end
      end
    end
  end
end
