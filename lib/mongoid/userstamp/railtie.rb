# -*- encoding : utf-8 -*-

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
    # mongoid_userstamp was not explicitly called
    config.to_prepare do
      Mongoid::Userstamp.model_classes.each do |model_class|
        unless model_class.included_modules.include?(Mongoid::Userstamp::Model)
          model_class.send(:include, Mongoid::Userstamp::Model)
        end
      end
    end

    # Set current_user from controller reader method
    ActiveSupport.on_load :action_controller do
      before_action do |c|
        Mongoid::Userstamp.user_classes.each do |user_class|
          begin
            user_class.current = c.send(user_class.mongoid_userstamp_user.reader)
          rescue
          end
        end
      end
    end
  end
end
end
