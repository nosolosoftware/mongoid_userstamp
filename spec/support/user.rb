# -*- encoding : utf-8 -*-
class User
  include Mongoid::Document
  include Mongoid::Userstamp::UserMixin

  field :name
end
