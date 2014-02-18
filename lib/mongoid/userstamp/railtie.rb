# -*- encoding : utf-8 -*-
module Mongoid
  module Userstamp
    class Railtie < Rails::Railtie

      ActiveSupport.on_load :action_controller do
        before_filter do |c|
          #### The below code is added for backwards compatibility so that the below works as well. In this case :default config is used.
          #
          # class Article
          #   include Mongoid::Userstamp
          # end
          #
          Mongoid::Userstamp.timestamped_models.each do |model|
            unless model.included_modules.include?(Mongoid::Userstamp::Userstampable)
              model.send(:include, Mongoid::Userstamp::Userstampable)
            end
          end if Mongoid::Userstamp.timestamped_models

          Mongoid::Userstamp.configs.each_pair do |key, config|
            begin
              unless config.user_model.respond_to?(:current)
                config.user_model.send(:include, Mongoid::Userstamp::User)
              end

              config.user_model.current = c.send(config.user_reader)
            rescue
            end
          end

        end
      end

    end
  end
end
