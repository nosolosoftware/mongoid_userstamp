# -*- encoding : utf-8 -*-

module Mongoid
module Userstamp

  class Railtie < Rails::Railtie

    # Include Mongoid::Userstamp::User into User class, if not already done
    initializer 'mongoid_userstamp.setup_user_classes' do |app|
      Mongoid::Userstamp.user_classes.each do |user_class|
        unless user_class.included_modules.include?(Mongoid::Userstamp::User)
          user_class.send(:include, Mongoid::Userstamp::User)
        end
      end
    end

    # Add userstamp to models where Mongoid::Userstamp was included, but
    # mongoid_userstamp was not explicitly called
    initializer 'mongoid_userstamp.setup_model_classes' do |app|
      Mongoid::Userstamp.model_classes.each do |model_class|
        unless model_class.included_modules.include?(Mongoid::Userstamp::Model)
          model_class.send(:include, Mongoid::Userstamp::Model)
        end
      end
    end

    # Set current_user from controller reader method
    initializer 'mongoid_userstamp.setup_current_user_before_filter' do |app|
      ActiveSupport.on_load :action_controller do
        before_filter do |c|
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
end
