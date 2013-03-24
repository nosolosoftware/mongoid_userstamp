# -*- encoding : utf-8 -*-
module Mongoid
  module Userstamp
    extend ActiveSupport::Concern

    autoload :Version, 'mongoid/userstamp/version'
    autoload :Railtie, 'mongoid/userstamp/railtie'
    autoload :Config, 'mongoid/userstamp/config'
    autoload :User, 'mongoid/userstamp/user'

    included do
      field self.userstamp_config.updated_column, :type => Object
      field self.userstamp_config.created_column, :type => Object

      before_save :set_updator
      before_create :set_creator

      define_method self.userstamp_config.updated_accessor do
        updated_col = self.send(self.userstamp_config.updated_column)
        updated_col ? self.userstamp_config.user_model.find(updated_col) : nil
      end

      define_method self.userstamp_config.created_accessor do
        created_col = self.send(self.userstamp_config.created_column)
        created_col ? self.userstamp_config.user_model.find(created_col) : nil
      end

      protected
        def set_updator
          return unless self.userstamp_config.user_model.respond_to? :current
          column = "#{self.userstamp_config.updated_column.to_s}=".to_sym

          self.send(column, self.userstamp_config.user_model.current.try(:id))
        end

        def set_creator
          return unless self.userstamp_config.user_model.respond_to? :current
          column = "#{self.userstamp_config.created_column.to_s}=".to_sym

          self.send(column, self.userstamp_config.user_model.current.try(:id))
        end
    end

    module ClassMethods
      def userstamp_config
        @userstamp_config ||= Mongoid::Userstamp::Config.new
      end
    end
  end
end
