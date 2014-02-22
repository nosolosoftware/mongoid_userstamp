# -*- encoding : utf-8 -*-
module Mongoid
module Userstamp

  class Railtie < Rails::Railtie

    ActiveSupport.on_load :action_controller do

      before_filter do |c|

        Mongoid::Userstamp.config.user_configs.each do |user_config|
          unless user_config.user_class.respond_to? :current
            user_config.user_class.send(:include, Mongoid::Userstamp::User)
          end

          # TODO FIX THIS
          begin
            user_config.user_class.user_model.current = c.send(user_config.reader)
          rescue
          end
        end
      end
    end
  end
end
end
