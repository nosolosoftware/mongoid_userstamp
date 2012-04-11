# -*- encoding : utf-8 -*-
module Mongoid
  module Userstamp
    module User
      extend ActiveSupport::Concern

      included do
        include Mongoid::Timestamps

        def current?
          !Thread.current[:user].nil? && self.id == Thread.current[:user].id
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

