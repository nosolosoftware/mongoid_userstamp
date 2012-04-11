# -*- encoding : utf-8 -*-
module Mongoid
  module Userstamp
    class Railtie < Rails::Railtie
      ActiveSupport.on_load :action_controller do
        unless Mongoid::Userstamp.configuration.user_model.respond_to? :current
          Mongoid::Userstamp.configuration.user_model.send(
            :include,
            Mongoid::Userstamp::User
          )
        end

        before_filter do |c|
          Mongoid::Userstamp.configuration.user_model.current = c.send(Mongoid::Userstamp.configuration.user_reader)
        end
      end
    end
  end
end

