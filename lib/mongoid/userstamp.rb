# -*- encoding : utf-8 -*-
module Mongoid
  module Userstamp
    extend ActiveSupport::Concern

    autoload :Version, 'mongoid/userstamp/version'
    autoload :Railtie, 'mongoid/userstamp/railtie'
    autoload :Config, 'mongoid/userstamp/config'
    autoload :User, 'mongoid/userstamp/user'

    included do
      field Mongoid::Userstamp.configuration.updated_column, :type => Object
      field Mongoid::Userstamp.configuration.created_column, :type => Object

      before_save :set_updator
      before_create :set_creator

      define_method Mongoid::Userstamp.configuration.updated_accessor do
        updated_col = self.send(Mongoid::Userstamp.configuration.updated_column)
        updated_col ? Mongoid::Userstamp.configuration.user_model.find(updated_col) : nil
      end

      define_method Mongoid::Userstamp.configuration.created_accessor do
        created_col = self.send(Mongoid::Userstamp.configuration.created_column)
        created_col ? Mongoid::Userstamp.configuration.user_model.find(created_col) : nil
      end

      protected
        def set_updator
          return unless Mongoid::Userstamp.configuration.user_model.respond_to? :current
          column = "#{Mongoid::Userstamp.configuration.updated_column.to_s}=".to_sym

          self.send(column, Mongoid::Userstamp.configuration.user_model.current.try(:id))
        end

        def set_creator
          return unless Mongoid::Userstamp.configuration.user_model.respond_to? :current
          column = "#{Mongoid::Userstamp.configuration.created_column.to_s}=".to_sym

          self.send(column, Mongoid::Userstamp.configuration.user_model.current.try(:id))
        end
    end

    class << self
      def configure(&block)
        @@configuration = Mongoid::Userstamp::Config.new(&block)
      end

      def configuration
        @@configuration ||= Mongoid::Userstamp::Config.new
      end
    end
  end
end
