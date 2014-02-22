# -*- encoding : utf-8 -*-

module Mongoid
module Userstamp

  module Userstampable

    extend ActiveSupport::Concern

    included do

      belongs_to Mongoid::Userstamp.config.created_by_name,
                 Mongoid::Userstamp::Userstampable.relation_opts(Mongoid::Userstamp.config.updated_column_opts)

      belongs_to Mongoid::Userstamp.config.updated_by_name,
                 Mongoid::Userstamp::Userstampable.relation_opts(Mongoid::Userstamp.config.updated_column_opts)

      before_create :set_created_by

      before_save :set_updated_by

      protected

      def set_created_by
        return if !Mongoid::Userstamp.has_current_user? || self.send(Mongoid::Userstamp.config.created_by_name)
        self.send("#{Mongoid::Userstamp.config.created_by_name}=", Mongoid::Userstamp.current_user)
      end

      def set_updated_by
        return if !Mongoid::Userstamp.has_current_user?
        self.send("#{Mongoid::Userstamp.config.updated_by_name}=", Mongoid::Userstamp.current_user)
      end
    end

    class << self

      def relation_opts(opts)
        opts ||= {}
        if Mongoid::Userstamp.config.polymorphic
          opts.merge!({polymorphic: Mongoid::Userstamp.config.polymorphic})
        else
          opts.merge!({class_name: Mongoid::Userstamp.config.user_configs.first.model})
        end
        opts
      end
    end
  end
end
end
