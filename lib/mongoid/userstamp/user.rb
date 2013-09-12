# -*- encoding : utf-8 -*-
module Mongoid
  module Userstamp
    module User
      extend ActiveSupport::Concern

      included do
        def current?
          !Thread.current[:user].nil? && self._id == Thread.current[:user]._id
        end
      end

      module ClassMethods
        def current
          Thread.current[:user]
        end

        def current=(value)
          Thread.current[:user] = value
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
