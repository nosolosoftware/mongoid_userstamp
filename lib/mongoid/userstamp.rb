# -*- encoding : utf-8 -*-

module Mongoid
  module Userstamp
    extend ActiveSupport::Concern

    include Mongoid::Userstamp::Userstampable

    class << self
      include Mongoid::Userstamp::Configurable
      include Mongoid::Userstamp::Controller
    end
  end
end
