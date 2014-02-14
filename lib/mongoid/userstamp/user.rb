# -*- encoding : utf-8 -*-
module Mongoid
  module Userstamp
    module User
      extend ActiveSupport::Concern

      included do
        cattr_accessor :user_key do
          "mongoid_userstamp/#{self.to_s.underscore}".to_sym
        end

        def current?
          !Thread.current[user_key].nil? && self._id == Thread.current[user_key]._id
        end
      end

      module ClassMethods
        def current
          Thread.current[user_key]
        end

        def current=(value)
          Thread.current[user_key] = value
        end

        def do_as(user, &block)
          old = self.current

          begin
            self.current = user
            response = block.call unless block.nil?
          ensure
            self.current = old
          end

          response
        end
      end
    end
  end
end
