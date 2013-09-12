# -*- encoding : utf-8 -*-
module Mongoid
  module Userstamp
    class Config
      attr_accessor :user_reader
      attr_writer   :user_model

      attr_accessor :created_column
      attr_accessor :created_column_opts
      attr_accessor :created_accessor

      attr_accessor :updated_column
      attr_accessor :updated_column_opts
      attr_accessor :updated_accessor

      def initialize(&block)
        @user_reader = :current_user
        @user_model = :user

        @created_column = :created_by
        @created_accessor = :creator

        @updated_column = :updated_by
        @updated_accessor = :updater

        instance_eval(&block) if block_given?
      end

      def user_model
        @user_model.to_s.classify.constantize
      end
    end
  end
end
