# -*- encoding : utf-8 -*-

module Mongoid
module Userstamp

  module User

    extend ActiveSupport::Concern

    included do

      Mongoid::Userstamp.add_user_class(self)

      def current?
        self._id == Mongoid::Userstamp.current_user(self.class).try(:_id)
      end
    end

    module ClassMethods

      def current
        Mongoid::Userstamp.current_user(self)
      end

      def current=(value)
        Mongoid::Userstamp.set_current_user(value, self)
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

      def mongoid_userstamp_user(opts = {})
        @mongoid_userstamp_user ||= Mongoid::Userstamp::UserConfig.new(opts)
      end
    end
  end
end
end
