# -*- encoding : utf-8 -*-

module Mongoid
module Userstamp

  module Configurable

    def config(&block)
      @config ||= Mongoid::Userstamp::Config::AppConfig.new(&block)
    end

    # @deprecated
    def configure(&block)
      warn 'Mongoid::Userstamp.configure is deprecated. Please use Mongoid::Userstamp.config instead'
      config(&block)
    end
  end
end
end
