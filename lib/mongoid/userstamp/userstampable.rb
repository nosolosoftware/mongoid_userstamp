# -*- encoding : utf-8 -*-

module Mongoid
  module Userstamp
    module Userstampable
      extend ActiveSupport::Concern

      included do

        field userstamp_config.updated_column, Mongoid::Userstamp.field_opts(userstamp_config.updated_column_opts)
        field userstamp_config.created_column, Mongoid::Userstamp.field_opts(userstamp_config.created_column_opts)

        before_save :set_updater
        before_create :set_creator

        def userstamp_config
          self.class.userstamp_config
        end

        define_method userstamp_config.updated_accessor do
          Mongoid::Userstamp.find_user userstamp_config.user_model, self.send(userstamp_config.updated_column)
        end

        define_method userstamp_config.created_accessor do
          Mongoid::Userstamp.find_user userstamp_config.user_model, self.send(userstamp_config.created_column)
        end

        define_method "#{userstamp_config.updated_accessor}=" do |user|
          self.send("#{userstamp_config.updated_column}=", Mongoid::Userstamp.extract_bson_id(user))
        end

        define_method "#{userstamp_config.created_accessor}=" do |user|
          self.send("#{userstamp_config.created_column}=", Mongoid::Userstamp.extract_bson_id(user))
        end

        protected

        def set_updater
          return if !self.class.has_current_user?
          self.send("#{userstamp_config.updated_accessor}=", self.class.current_user)
        end

        def set_creator
          return if !self.class.has_current_user? || self.send(userstamp_config.created_column)
          self.send("#{userstamp_config.created_accessor}=", self.class.current_user)
        end
      end

      module ClassMethods
        def has_current_user?
          userstamp_config.user_model.respond_to?(:current)
        end

        def current_user
          userstamp_config.user_model.try(:current)
        end
      end
    end
  end
end
