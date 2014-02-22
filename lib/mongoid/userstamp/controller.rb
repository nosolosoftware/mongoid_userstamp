# -*- encoding : utf-8 -*-

module Mongoid
module Userstamp

  module Controller

    #THREAD_DOMAIN = 'mongoid_userstamp/'

    def userstamp_key(model)
      # need to map default here
      "mongoid_userstamp/#{model.to_s.underscore}".to_sym
    end

    def has_current_user?(model = nil)
      current_user.present
    end

    def current_user(model = nil)
      model ||= user_class
      store[userstamp_key(model)]
    end

    def current_user=(value)
      store[userstamp_key(value.class)] = value
    end

    def user_model
      if Mongoid::Userstamp.config.polymorphic
        store['mongoid_userstamp/user_class'] || :default
      else
        :default
      end
    end

    def user_model=(klass)
      store['mongoid_userstamp/user_class'] = klass
    end

    def user_class
      case user_model
        when :default, 'default'
          Mongoid::Userstamp.config.user_configs.first.model.to_s.classify.constantize
        when Class
          user_model
        when Symbol, String
          user_class.classify.constantize
      end
    end

    def store
      Mongoid::Userstamp.config.use_request_store ? RequestStore.store : Thread.current
    end

    def with_user_class(klass, &block)
      old_klass = user_class
      begin
        user_class = klass
        response = block.call unless block.nil?
      ensure
        user_class = old_klass
      end
      response
    end
  end
end
end
