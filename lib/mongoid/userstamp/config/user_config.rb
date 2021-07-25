# frozen_string_literal: true

module Mongoid
  module Userstamp
    class UserConfig
      def initialize(options = {})
        @controller_current_user = options.delete(:controller_current_user)
        raise ArgumentError.new("Invalid keys found: #{options.keys.join(', ')}") unless options.empty?
      end

      def controller_current_user
        @controller_current_user || Mongoid::Userstamp.config.controller_current_user
      end
    end
  end
end
