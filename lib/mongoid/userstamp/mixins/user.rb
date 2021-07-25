# frozen_string_literal: true

module Mongoid
  module Userstamp
    module User
      extend ActiveSupport::Concern

      included do
        Mongoid::Userstamp.add_user_class(self)

        def current_user?
          _id == Mongoid::Userstamp.current_user(self.class).try(:_id)
        end
      end

      class_methods do
        def userstamp_user(options = {})
          _userstamp_user_config(options)
        end

        def _userstamp_user_config(options = {})
          @_userstamp_user_config ||= Mongoid::Userstamp::UserConfig.new(options)
        end

        def current_user
          Mongoid::Userstamp.current_user(self)
        end

        def current_user=(value)
          Mongoid::Userstamp.set_current_user(value, self)
        end

        def do_as(user, &_block)
          old = current_user
          self.current_user = user
          yield
        ensure
          self.current_user = old
        end
      end
    end
  end
end
