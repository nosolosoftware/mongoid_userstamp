# frozen_string_literal: true

module Mongoid
  module Userstamp
    class GlobalConfig
      attr_accessor :created_by_field,
                    :updated_by_field,
                    :controller_current_user

      def initialize(&block)
        @created_by_field = :created_by
        @updated_by_field = :updated_by
        @controller_current_user = :current_user

        instance_eval(&block) if block_given?
      end
    end
  end
end
