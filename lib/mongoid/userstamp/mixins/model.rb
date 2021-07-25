# frozen_string_literal: true

module Mongoid
  module Userstamp
    module Model
      extend ActiveSupport::Concern

      included do
        belongs_to _userstamp_model_config.created_by_field, class_name: _userstamp_model_config.user_class_name,
                                                             inverse_of: nil, optional: true
        belongs_to _userstamp_model_config.updated_by_field, class_name: _userstamp_model_config.user_class_name,
                                                             inverse_of: nil, optional: true

        before_create :set_created_by
        before_save :set_updated_by

        protected

        def set_created_by
          current_user = Mongoid::Userstamp.current_user(self.class._userstamp_model_config.user_class_name)
          return if current_user.blank? || send(self.class._userstamp_model_config.created_by_field)

          send("#{self.class._userstamp_model_config.created_by_field}=", current_user)
        end

        def set_updated_by
          current_user = Mongoid::Userstamp.current_user(self.class._userstamp_model_config.user_class_name)
          return if current_user.blank? || send("#{self.class._userstamp_model_config.updated_by_field}_id_changed?")

          send("#{self.class._userstamp_model_config.updated_by_field}=", current_user)
        end
      end
    end

    class_methods do
      def current_user
        Mongoid::Userstamp.current_user(_userstamp_model_config.user_class_name)
      end
    end
  end
end
