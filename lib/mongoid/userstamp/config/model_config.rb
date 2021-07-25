# frozen_string_literal: true

module Mongoid
  module Userstamp
    class ModelConfig
      def initialize(options = {})
        @user_class_name = options.delete(:user_class_name)
        @created_by_field = options.delete(:created_by_field)
        @updated_by_field = options.delete(:updated_by_field)
        raise ArgumentError.new("Invalid keys found: #{options.keys.join(', ')}") unless options.empty?
      end

      def user_class_name
        @user_class_name || Mongoid::Userstamp.user_classes.first.to_s
      end

      def created_by_field
        @created_by_field || Mongoid::Userstamp.config.created_by_field
      end

      def updated_by_field
        @updated_by_field || Mongoid::Userstamp.config.updated_by_field
      end
    end
  end
end
