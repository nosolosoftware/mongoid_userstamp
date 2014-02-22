# -*- encoding : utf-8 -*-
module Mongoid
module Userstamp

  module User

    extend ActiveSupport::Concern

    included do

      def current?
        self._id == Mongoid::Userstamp.current_user(self.class).try(:_id)
      end
    end

    module ClassMethods

      def current
        Mongoid::Userstamp.current_user(self)
      end

      def current=(value)
        Mongoid::Userstamp.current_user = value
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
