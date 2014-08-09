# -*- encoding : utf-8 -*-

module Mongoid
module Userstamp

  module Model

    extend ActiveSupport::Concern

    included do

      belongs_to mongoid_userstamp_config.created_name, class_name: mongoid_userstamp_config.user_model, inverse_of: nil
      belongs_to mongoid_userstamp_config.updated_name, class_name: mongoid_userstamp_config.user_model, inverse_of: nil

      before_create :set_created_by
      before_save :set_updated_by

      protected

      def set_created_by
        current_user = Mongoid::Userstamp.current_user(self.class.mongoid_userstamp_config.user_model)
        return if current_user.blank? || self.send(self.class.mongoid_userstamp_config.created_name)
        self.send("#{self.class.mongoid_userstamp_config.created_name}=", current_user)
      end

      def set_updated_by
        current_user = Mongoid::Userstamp.current_user(self.class.mongoid_userstamp_config.user_model)
        return if current_user.blank?
        self.send("#{self.class.mongoid_userstamp_config.updated_name}=", current_user)
      end
    end

    module ClassMethods

      def current_user
        Mongoid::Userstamp.current_user(mongoid_userstamp_config.user_model)
      end
    end
  end
end
end
