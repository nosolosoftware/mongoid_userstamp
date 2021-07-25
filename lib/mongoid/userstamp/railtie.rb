# frozen_string_literal: true

module Mongoid
  module Userstamp
    class Railtie < Rails::Railtie
      # Include Mongoid::Userstamp::User into User class, if not already done
      config.to_prepare do
        Mongoid::Userstamp.user_classes.each do |user_class|
          unless user_class.included_modules.include?(Mongoid::Userstamp::User)
            user_class.send(:include, Mongoid::Userstamp::User)
          end
        end
      end

      # Add userstamp to models where Mongoid::Userstamp was included, but
      # userstamp was not explicitly called
      config.to_prepare do
        Mongoid::Userstamp.model_classes.each do |model_class|
          unless model_class.included_modules.include?(Mongoid::Userstamp::Model)
            model_class.send(:include, Mongoid::Userstamp::Model)
          end
        end
      end

      # Set current_user from controller reader method
      ActiveSupport.on_load :action_controller do
        set_current_user = proc do |controller|
          Mongoid::Userstamp.user_classes.each do |user_class|
            method = user_class.userstamp_user.controller_current_user
            next unless method && controller.respond_to?(method)
            user_class.current_user = controller.send(method)
          rescue StandardError # rubocop:disable Lint/SuppressedException
          end
        end

        before_action {|c| set_current_user.call(c) }
      end
    end
  end
end
