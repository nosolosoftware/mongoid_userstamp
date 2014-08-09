# -*- encoding : utf-8 -*-

module Mongoid
module Userstamp

  class UserConfig

    def initialize(opts = {})
      @reader = opts.delete(:reader)
    end

    def reader
      @reader || Mongoid::Userstamp.config.user_reader
    end
  end
end
end
