# -*- encoding : utf-8 -*-
module Mongoid
  module Userstamp
    class Railtie < Rails::Railtie
      ActiveSupport.on_load :action_controller do
        before_filter do |c|
          unless Mongoid::Userstamp.config.user_model.respond_to? :current
            Mongoid::Userstamp.config.user_model.send(
              :include,
              Mongoid::Userstamp::User
            )
          end

          Mongoid::Userstamp.config.user_model.current = c.send(Mongoid::Userstamp.config.user_reader)
        end
      end
    end
  end
end
